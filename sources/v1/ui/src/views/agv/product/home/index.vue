<template>
  <div class="flex-box flex-direction-column" style="height:100%">
    <div class="content flex-box fillParent">
      <!-- 左边菜单 -->
      <div class="left-menu">
        <div
          class="menu-item current-menu flex-box flex-justify-content-center flex-align-items-center"
        >配送管理</div>
        <div
          class="menu-item flex-box flex-justify-content-center flex-align-items-center"
          @click="turn2"
        >波次管理</div>
        <div
          class="menu-item flex-box flex-justify-content-center flex-align-items-center"
          @click="turn3"
        >叫料历史</div>
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
          <div
            class="btn btn-default btn-add flex-box flex-justify-content-center flex-align-items-center"
            @click="addWave()"
          >新增</div>
        </div>
        <!-- 表头内容 -->
        <div class="flex-box data-header-content flex-align-items-center" style="width:100%;">
          <div class="data-header-name">名称</div>
          <div class="data-header-num">数量</div>
          <!-- <div class="data-header-done">已验收</div> -->
          <div class="data-header-operation"></div>
        </div>
        <!-- 表格内容 -->
        <div class="flex-box data-content flex-direction-column" style="width:100%; color:yellow;">
          <div v-for="(item) in waves" :key="item.id">
            <div class="data-content-produce-row flex-box flex-align-items-center">
              <div
                class="data-name"
              >{{item.materialName+" （"+item.productLineCode+"） "+item.executionTime}}</div>
              <div class="bom-num"></div>
              <!-- <div class="bom-done"></div> -->
              <div class="data-content-produce-operation flex-box flex-align-items-center">
                <div class="wave-add" @click="addWave(item)">新增</div>
                <div class="wave-delete" @click="deleteProduce(item)">删除</div>
              </div>
            </div>
            <div class="data-wave" v-for="(wave,index) in item.waveModels" :key="wave.id">
              <div class="data-content-wave-row flex-box flex-align-items-center">
                <div class="wave-name">{{'波次' + (index + 1)+" ["+formateState(wave.state)+"]"}}</div>
                <div class="bom-num"></div>
                <!-- <div class="bom-done"></div> -->
                <div class="data-content-wave-operation flex-box flex-align-items-center">
                  <div class="wave-delete" @click="deleteWave(wave)">删除</div>
                </div>
              </div>
              <div
                v-for="(bom) in wave.waveDetailModels"
                :key="bom.id"
                class="flex-box data-content-row"
              >
                <div
                  class="bom-name flex-box flex-align-items-center flex-justify-content-center"
                >{{bom.materialName}}</div>
                <div
                  class="bom-num flex-box flex-align-items-center flex-justify-content-center"
                >{{bom.count}}</div>
                <!-- <div
                  class="bom-done flex-box flex-align-items-center flex-justify-content-center"
                >{{bom.done}}</div>-->
                <div class="data-content-operation flex-box flex-align-items-center">
                  <div class="bom-delete" @click="deleteBom(bom.id)">删除</div>
                  <div class="bom-update" @click="updateBom(bom)">修改</div>
                </div>
              </div>
              <div class="flex-box data-content-row">
                <div class="bom-add-icon" @click="addBom(wave)"></div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <el-dialog
      v-if="state.editBomVisible"
      :visible.sync="state.editBomVisible"
      title="修改原料"
      class="dialog-transfer"
    >
      <EditBom :bom="editBom" @toggleShow="toggleShow" @reloadWaves="getWaves"></EditBom>
    </el-dialog>
    <el-dialog
      v-if="state.addBomVisible"
      :visible.sync="state.addBomVisible"
      title="添加原料"
      class="dialog-transfer"
    >
      <AddBom :bom="addBomWave" @toggleShow="toggleShow" @reloadWaves="getWaves"></AddBom>
    </el-dialog>
  </div>
</template>

<script>
  import './home.scss';
  import EditBom from './editBom';
  import AddBom from './addBom';
  import request from '@/utils/request';
  import Constants from '@/utils/constants';
  import { isEmpty } from '@/utils/helper';
  import { Loading } from 'element-ui';

  // 配送管理
  export default {
    name: 'home',
    components: { EditBom, AddBom },
    created() {
      this.loadingInfo();
    },
    data() {
      return {
        state: {
          editBomVisible: false,
          addBomVisible: false
        },
        // 加载对象
        load: null,
        editBom: null,
        addBomWave: null,
        waves: [],
        waveState: 0
      };
    },
    methods: {
      loadingInfo() {
        this.$store.dispatch('updateTitle', '配送管理');
        this.getWaves();
      },
      showAll() {
        this.waveState = null;
        this.getWaves();
      },
      showUnFinish() {
        this.waveState = 0;
        this.getWaves();
      },
      // 跳转到波次管理页面
      turn2() {
        this.$router.push({ path: '/agv/wave' });
      },
      // 跳转到历史叫料页面
      turn3() {
        this.$router.push({ path: '/agv/call/history' });
      },
      // 删除原料 -删除完后需要刷新
      deleteBom(bomId) {
        request({
          url: '/agv/waves/deleteDetail/' + bomId,
          method: 'DELETE'
        })
          .then(response => {
            if (response.errno === 0) {
              this.getWaves();
              // 如果遮罩层存在
              if (!isEmpty(this.load)) {
                this.load.close();
              }
            }
          })
          .catch(_ => {
            this.load = this.showErrorMessage('服务器请求失败');
          });
      },
      // 修改原料信息
      updateBom(bom) {
        this.editBom = bom;
        this.state.editBomVisible = true;
      },
      addBom(wave) {
        this.addBomWave = wave;
        this.state.addBomVisible = true;
      },
      // 删除波次
      deleteWave(wave) {
        request({
          url: '/agv/waves/deleteWave',
          method: 'DELETE',
          params: {
            waveCode: wave.code
          }
        })
          .then(response => {
            if (response.errno === 0) {
              this.getWaves();
              // 如果遮罩层存在
              if (!isEmpty(this.load)) {
                this.load.close();
              }
            }
          })
          .catch(_ => {
            this.load = this.showErrorMessage('服务器请求失败');
          });
      },
      // 删除产品
      deleteProduce(produce) {
        request({
          url: '/agv/waves/deleteWaves',
          method: 'DELETE',
          data: produce
        })
          .then(response => {
            if (response.errno === 0) {
              this.getWaves();
              // 如果遮罩层存在
              if (!isEmpty(this.load)) {
                this.load.close();
              }
            }
          })
          .catch(_ => {
            this.load = this.showErrorMessage('服务器请求失败');
          });
      },
      // 根据产品 增加一个波次
      addWave(produce) {
        request({
          url: '/agv/waves',
          method: 'POST',
          data: produce
        })
          .then(response => {
            if (response.errno === 0) {
              this.getWaves();
              // 如果遮罩层存在
              if (!isEmpty(this.load)) {
                this.load.close();
              }
            }
          })
          .catch(_ => {
            this.load = this.showErrorMessage('服务器请求失败');
          });
      },
      toggleShow() {
        this.state.editBomVisible = false;
        this.state.addBomVisible = false;
      },
      getWaves() {
        request({
          url: '/agv/waves',
          method: 'get',
          params: {
            type: 1,
            teamId: 'uuidxxxxb03',
            state: this.waveState
          }
        })
          .then(response => {
            console.log('getWaves*****:', response);
            if (response.errno === 0) {
              if (!isEmpty(response.data)) {
                this.waves = response.data;
              }
              // 如果遮罩层存在
              if (!isEmpty(this.load)) {
                this.load.close();
              }
            }
          })
          .catch(_ => {
            this.load = this.showErrorMessage('服务器请求失败');
          });
      },
      // 格式化状态
      formateState(waveState) {
        let stateName = '';
        Constants.deliveryState.forEach(item => {
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
