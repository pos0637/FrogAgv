<template>
  <div class="flex-box flex-direction-column" style="height:100%">
    <div class="content flex-box fillParent">
      <!-- 左边菜单 -->
      <div class="left-menu">
        <div
          class="menu-item flex-box flex-justify-content-center flex-align-items-center"
          @click="turn('/dashboard')"
        >配送管理</div>
        <div
          class="menu-item current-menu flex-box flex-justify-content-center flex-align-items-center"
        >波次管理</div>
        <div
          v-if="auth==='admin'"
          class="menu-item flex-box flex-justify-content-center flex-align-items-center"
          @click="turn('/agv/setting')"
        >生产设置</div>
        <!-- <div
          class="menu-item flex-box flex-justify-content-center flex-align-items-center"
          @click="turn('/agv/call/history')"
        >叫料历史</div>-->
      </div>
      <!-- 右边内容 -->
      <div
        class="flex-box flex-direction-column"
        style="width:100%;margin-left:10px;margin-right:20px;"
      >
        <!-- 按钮 -->
        <div class="flex-box content-button flex-align-items-center">
          <div
            class="btn btn-default flex-box flex-justify-content-center flex-align-items-center"
            @click="showAll()"
          >显示所有</div>
          <div
            class="btn btn-default btn-click flex-box flex-justify-content-center flex-align-items-center"
            @click="showUnFinish()"
          >未完成</div>
        </div>
        <!-- 表头内容 -->
        <div class="flex-box data-header-content flex-align-items-center" style="width:100%;">
          <div class="data-header-sort">优先级</div>
          <div class="data-header-name">名称</div>
          <div class="data-header-num">数量</div>
          <!-- <div class="data-header-done">已验收</div> -->
          <div class="data-header-operation"></div>
        </div>
        <!-- 表格内容 -->
        <div class="flex-box data-content flex-direction-column" style="width:100%; color:yellow;">
          <draggable
            v-model="waves"
            :options="{animation:300}"
            @start="drag=true"
            @end="drag=false"
            @change="changeSort"
          >
            <div v-for="(item,index) in waves" :key="item.id" class="data-wave">
              <div
                class="data-content-produce-row flex-box flex-align-items-center"
                style="cursor: pointer;"
              >
                <div class="data-sort">{{'第' + (index + 1) + '波'+" ["+formateState(item.state)+"]"}}</div>
                <div
                  class="data-name"
                >{{item.materialName+" （"+item.productLineCode+"） "+item.executionTime}}</div>
                <!-- <div class="data-content-produce-operation flex-box flex-align-items-center">
                  <div class="wave-back" @click="backWave(item.id)">退货</div>
                  <div class="wave-save" @click="saveWave(item.id)">验收</div>
                </div>-->
              </div>
              <draggable
                v-model="item.waveDetailModels"
                @start="drag=true"
                @end="drag=false"
                @change="changeSort"
              >
                <div
                  v-for="(bom) in item.waveDetailModels"
                  :key="bom.id"
                  class="flex-box data-content-row"
                  style="cursor: pointer;"
                >
                  <div class="data-sort"></div>
                  <div
                    class="bom-name flex-box flex-align-items-center flex-justify-content-center"
                  >{{bom.materialName}}</div>
                  <div
                    class="bom-num flex-box flex-align-items-center flex-justify-content-center"
                  >{{bom.count}}</div>
                  <!-- <div
                    class="bom-done flex-box flex-align-items-center flex-justify-content-center"
                  >{{bom.done}}</div>-->
                  <!-- <div class="data-content-operation flex-box flex-align-items-center">
                    <div class="bom-back" @click="backBom(bom.id)">退货</div>
                    <div class="bom-save" @click="saveBom(bom.id)">验收</div>
                  </div>-->
                </div>
              </draggable>
            </div>
          </draggable>
        </div>
      </div>
    </div>

    <el-dialog :visible.sync="state.backBomVisible" title="原料退货" class="dialog-transfer">
      <BackBom :id="backBomId" @toggleShow="toggleShow"></BackBom>
    </el-dialog>
    <el-dialog :visible.sync="state.saveBomVisible" title="原料验收" class="dialog-transfer">
      <SaveBom :id="saveBomId" @toggleShow="toggleShow"></SaveBom>
    </el-dialog>
  </div>
</template>

<script>
  import draggable from 'vuedraggable';
  import '../home/home.scss';
  import BackBom from './backBom';
  import SaveBom from './saveBom';
  import request from '@/utils/request';
  import Constants from '@/utils/constants';
  import { isEmpty } from '@/utils/helper';
  import { Loading } from 'element-ui';

  const areaTypeString = process.env.AREA_TYPE;
  export default {
    name: 'home',
    components: { draggable, BackBom, SaveBom },
    created() {
      this.loadingInfo();
    },
    data() {
      return {
        state: {
          backBomVisible: false,
          saveBomVisible: false
        },
        // 加载对象
        load: null,
        waveState: 0,
        backBomId: null,
        saveBomId: null,
        waves: [],
        datas: [],
        teamId: '',
        areaType: 1, // 区域类型,默认灌装区 1:灌装区;2:包装区
        auth: 'user'
      };
    },
    methods: {
      loadingInfo() {
        this.teamId = this.$store.state.AgvHeader.teamId;
        this.auth = this.$store.state.AgvHeader.auth;
        this.formateAreaType();
        this.timer();
      },
      formateAreaType() {
        if (areaTypeString === 'filling') {
          this.areaType = 1;
          this.$store.dispatch('updateTitle', '灌装区波次管理');
        } else if (areaTypeString === 'packing') {
          this.areaType = 2;
          this.$store.dispatch('updateTitle', '包装区波次管理');
        }
      },
      timer() {
        this.getWaves();
        if (this.timer) {
          clearInterval(this.timer);
        }
        this.timer = setInterval(() => {
          this.getWaves();
        }, 5000);
      },
      showAll() {
        this.waveState = null;
        this.getWaves();
      },
      showUnFinish() {
        this.waveState = 0;
        this.getWaves();
      },
      getWaves() {
        request({
          url: '/agv/wavesPlan',
          method: 'GET',
          params: {
            type: this.areaType,
            teamId: this.teamId,
            state: this.waveState
          }
        })
          .then(response => {
            if (response.errno === 0) {
              if (!isEmpty(response.data)) {
                this.waves = response.data;
              }
            }
          })
          .catch(_ => {
            console.log(_);
          });
      },
      // 跳转到指定页面
      turn(url) {
        this.$router.push({ path: url });
      },
      // 原料退货
      backBom(bomId) {
        console.log('backBom>>>>>>>', bomId);
        this.backBomId = bomId;
      },
      // 原料验收
      saveBom(bomId) {
        console.log('saveBom>>>>>>>', bomId);
      },
      // 一波退货
      backWave(waveId) {
        console.log('backWave>>>>>>>', waveId);
      },
      // 一波验收
      saveWave(waveId) {
        console.log('backWave>>>>>>>', waveId);
      },
      // 拖动之后的顺序
      changeSort() {
        request({
          url: '/agv/waves/updateWaves',
          method: 'POST',
          data: this.waves
        })
          .then(response => {
            if (response.errno === 0) {
              this.getWaves();
            }
          })
          .catch(_ => {
            console.log(_);
          });
      },
      toggleShow() {
        this.backBomVisible = false;
        this.saveBomVisible = false;
      },
      // 格式化状态
      formateState(waveState) {
        let stateName = '';
        Constants.waveState.forEach(item => {
          if (item.value === waveState) {
            stateName = item.label;
          }
        });
        return stateName;
      },
      // 用遮罩层显示错误信息
      showErrorMessage(message) {
        const options = {
          lock: true,
          fullscreen: true,
          text: message,
          spinner: '',
          background: 'rgba(0, 0, 0, 0.7)'
        };
        return Loading.service(options);
      }
    }
  };
</script>
