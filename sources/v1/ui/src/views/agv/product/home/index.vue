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
          >显示所有</div>
          <div
            class="btn btn-default btn-click flex-box flex-justify-content-center flex-align-items-center"
          >未完成</div>
          <div
            class="btn btn-default btn-add flex-box flex-justify-content-center flex-align-items-center"
            @click="addWave(item.id)"
          >新增</div>
        </div>
        <!-- 表头内容 -->
        <div class="flex-box data-header-content flex-align-items-center" style="width:100%;">
          <div class="data-header-name">名称</div>
          <div class="data-header-num">数量</div>
          <div class="data-header-done">已验收</div>
          <div class="data-header-operation"></div>
        </div>
        <!-- 表格内容 -->
        <div class="flex-box data-content flex-direction-column" style="width:100%; color:yellow;">
          <div v-for="(item) in cData" :key="item.id">
            <div class="data-content-produce-row flex-box flex-align-items-center">
              <div class="data-name">{{item.name}}</div>
              <div class="bom-num"></div>
              <div class="bom-done"></div>
              <div class="data-content-produce-operation flex-box flex-align-items-center">
                <div class="wave-add" @click="addWave(item.id)">新增</div>
                <div class="wave-delete" @click="deleteProduce(item.id)">删除</div>
              </div>
            </div>
            <div class="data-wave" v-for="(wave,index) in item.waves" :key="wave.id">
              <div class="data-content-wave-row flex-box flex-align-items-center">
                <div class="wave-name">{{'波次' + (index + 1)}}</div>
                <div class="bom-num"></div>
                <div class="bom-done"></div>
                <div class="data-content-wave-operation flex-box flex-align-items-center">
                  <div class="wave-delete" @click="deleteWave(wave.id)">删除</div>
                </div>
              </div>
              <div v-for="(bom) in wave.boms" :key="bom.id" class="flex-box data-content-row">
                <div
                  class="bom-name flex-box flex-align-items-center flex-justify-content-center"
                >{{bom.name}}</div>
                <div
                  class="bom-num flex-box flex-align-items-center flex-justify-content-center"
                >{{bom.num}}</div>
                <div
                  class="bom-done flex-box flex-align-items-center flex-justify-content-center"
                >{{bom.done}}</div>
                <div class="data-content-operation flex-box flex-align-items-center">
                  <div class="bom-delete" @click="deleteBom(bom.id)">删除</div>
                  <div class="bom-update" @click="updateBom(bom.id)">修改</div>
                </div>
              </div>
              <div class="flex-box data-content-row">
                <div class="bom-add-icon" @click="addBom(wave.id)"></div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <el-dialog :visible.sync="state.editBomVisible" title="修改原料" class="dialog-transfer">
      <EditBom :id="editBomId" @toggleShow="toggleShow"></EditBom>
    </el-dialog>
    <el-dialog :visible.sync="state.addBomVisible" title="添加原料" class="dialog-transfer">
      <AddBom :id="addBomWaveId" @toggleShow="toggleShow"></AddBom>
    </el-dialog>
  </div>
</template>

<script>
  import './home.scss';
  import EditBom from './editBom';
  import AddBom from './addBom';
  // 配送管理
  export default {
    name: 'home',
    components: { EditBom, AddBom },
    created() {
      this.$store.dispatch('updateTitle', '配送管理');
    },
    data() {
      return {
        state: {
          editBomVisible: false,
          addBomVisible: false
        },
        editBomId: null,
        addBomWaveId: null,
        cData: [
          {
            id: 1,
            name: '产品A（L15）',
            waves: [
              {
                id: 1,
                boms: [
                  { id: 1, name: '原料A', num: 50, done: 50 },
                  { id: 2, name: '原料B', num: 50, done: 45 },
                  { id: 3, name: '原料C', num: 50, done: 45 }
                ]
              },
              {
                id: 2,
                boms: [
                  { id: 1, name: '原料A', num: 50, done: 50 },
                  { id: 2, name: '原料B', num: 50, done: 45 }
                ]
              }
            ]
          },
          {
            id: 2,
            name: '产品B（L15）',
            waves: [
              {
                id: 2,
                boms: [
                  { id: 1, name: '原料A', num: 50, done: 50 },
                  { id: 2, name: '原料B', num: 50, done: 45 }
                ]
              }
            ]
          }
        ]
      };
    },
    methods: {
      // 跳转到波次管理页面
      turn2() {
        this.$router.push({ path: '/agv/wave' });
      },
      // 跳转到历史叫料页面
      turn3() {
        this.$router.push({ path: '/agv/call/history' });
      },
      // 删除原料 -删除完后需要刷新cData
      deleteBom(bomId) {
        console.log('deleteBom>>>>>>' + bomId);
      },
      // 修改原料信息
      updateBom(bomId) {
        this.editBomId = bomId;
        this.state.editBomVisible = true;
      },
      addBom(waveId) {
        console.log('addBom----waveId', waveId);
        this.addBomWaveId = waveId;
        this.state.addBomVisible = true;
      },
      // 删除波次
      deleteWave(waveId) {
        console.log('deleteWave>>>>>>' + waveId);
      },
      // 删除产品
      deleteProduce(produceId) {
        console.log('deleteProduce>>>>>>' + produceId);
      },
      // 根据产品ID 增加一个波次
      addWave(produceId) {
        console.log('addWave>>>>>>' + produceId);
      },
      toggleShow() {
        this.state.editBomVisible = false;
        this.state.addBomVisible = false;
      }
    }
  };
</script>
