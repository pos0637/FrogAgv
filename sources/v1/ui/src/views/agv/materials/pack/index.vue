<template>
  <div class="flex-box flex-direction-column" style="height:100%">
    <div class="content flex-box fillParent">
      <!-- 左边菜单 -->
      <div class="left-menu">
        <div
          class="menu-item flex-box flex-justify-content-center flex-align-items-center"
          @click="turn('/materials/unpack')"
        >拆包配货</div>
        <div
          class="menu-item current-menu flex-box flex-justify-content-center flex-align-items-center"
        >包装配货</div>
        <div
          class="menu-item flex-box flex-justify-content-center flex-align-items-center"
          @click="turn('/materials/stock')"
        >
          备货任务
          <span class="pick">{{this.num}}</span>
        </div>
      </div>
      <!-- 右边内容 -->
      <div class="flex-box" style="width:100%;margin-left:10px;margin-right:20px;">
        <!-- 配送任务 -->
        <div class="task-list-box">
          <div class="task-list-title">配送任务</div>
          <div v-for="(item) in datas" :key="item.id">
            <div class="task-list-name">{{item.name}}</div>
            <div v-for="(bom) in item.boms" :key="bom.id" class="flex-box" style=" margin-top:5px;">
              <div class="task-list-bom-name">{{bom.name}}</div>
              <div class="task-list-bom-num">{{bom.num}}</div>
            </div>
          </div>
        </div>
        <!-- 备货区 -->
        <div class="task-content">
          <div class="title">备货区</div>
          <div class="position-box flex-box flex-wrap">
            <div v-for="(item) in cData" :key="item.id">
              <div
                class="position position-pointer"
                v-if="item.bomId"
                @click="taskOut(item.bomId,item.name)"
              >{{item.bomName}}</div>
              <div class="position" v-else></div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <el-dialog
      :visible.sync="state.taskOutVisible"
      :title="taskOutPositionName"
      class="dialog-transfer"
    >
      <TaskOut :id="taskOutBomId" @toggleShow="toggleShow"></TaskOut>
    </el-dialog>
  </div>
</template>

<script>
  import '../../product/home/home.scss';
  import '../../disinfection/task/task.scss';
  import TaskOut from './taskOut';

  export default {
    name: 'home',
    components: { TaskOut },
    created() {
      this.$store.dispatch('updateTitle', '包材仓-拆包间包装任务');
    },
    data() {
      return {
        num: '99+',
        state: {
          taskOutVisible: false
        },
        taskOutPositionName: '',
        taskOutBomId: null,
        cData: [
          { id: 1, name: '库位1', bomName: 'BOM1', bomId: '1' },
          { id: 2, name: '库位2', bomName: '' },
          { id: 3, name: '库位3', bomName: '' },
          { id: 4, name: '库位4', bomName: '' },
          { id: 5, name: '库位5', bomName: 'BOM2', bomId: '2' },
          { id: 6, name: '库位6', bomName: '' },
          { id: 7, name: '库位7', bomName: '' },
          { id: 8, name: '库位8', bomName: '' },
          { id: 11, name: '库位1', bomName: 'BOM1', bomId: '1' },
          { id: 12, name: '库位2', bomName: '' },
          { id: 13, name: '库位3', bomName: '' },
          { id: 14, name: '库位4', bomName: '' },
          { id: 15, name: '库位5', bomName: 'BOM2', bomId: '2' },
          { id: 16, name: '库位6', bomName: '' },
          { id: 17, name: '库位7', bomName: '' },
          { id: 18, name: '库位8', bomName: '' },
          { id: 21, name: '库位1', bomName: 'BOM1', bomId: '1' },
          { id: 22, name: '库位2', bomName: '' },
          { id: 23, name: '库位3', bomName: '' },
          { id: 24, name: '库位4', bomName: '' },
          { id: 25, name: '库位5', bomName: 'BOM2', bomId: '2' },
          { id: 26, name: '库位6', bomName: '' },
          { id: 31, name: '库位1', bomName: 'BOM1', bomId: '1' },
          { id: 322, name: '库位2', bomName: '' },
          { id: 323, name: '库位3', bomName: '' },
          { id: 324, name: '库位4', bomName: '' },
          { id: 35, name: '库位5', bomName: 'BOM2', bomId: '2' },
          { id: 36, name: '库位6', bomName: '' },
          { id: 37, name: '库位7', bomName: '' },
          { id: 38, name: '库位8', bomName: '' },
          { id: 41, name: '库位1', bomName: 'BOM1', bomId: '1' },
          { id: 42, name: '库位2', bomName: '' },
          { id: 43, name: '库位3', bomName: '' },
          { id: 44, name: '库位4', bomName: '' },
          { id: 45, name: '库位5', bomName: 'BOM2', bomId: '2' },
          { id: 46, name: '库位6', bomName: '' },
          { id: 47, name: '库位7', bomName: '' },
          { id: 48, name: '库位8', bomName: '' },
          { id: 51, name: '库位1', bomName: 'BOM1', bomId: '1' },
          { id: 52, name: '库位2', bomName: '' },
          { id: 53, name: '库位3', bomName: '' },
          { id: 54, name: '库位4', bomName: '' },
          { id: 55, name: '库位5', bomName: 'BOM2', bomId: '2' },
          { id: 56, name: '库位6', bomName: '' },
          { id: 57, name: '库位7', bomName: '' },
          { id: 58, name: '库位8', bomName: '' }
        ],
        datas: [
          {
            id: 1,
            name: '产品A(L15）',
            boms: [
              { id: 1, name: '原料A', num: 50 },
              { id: 2, name: '原料B', num: 50 },
              { id: 3, name: '原料C', num: 50 },
              { id: 4, name: '原料D', num: 50 }
            ]
          },
          {
            id: 2,
            name: '产品B(L15）',
            boms: [
              { id: 1, name: '原料A', num: 50 },
              { id: 2, name: '原料B', num: 50 },
              { id: 3, name: '原料C', num: 50 }
            ]
          },
          {
            id: 3,
            name: '产品C(L15）',
            boms: [
              { id: 1, name: '原料A', num: 50 },
              { id: 2, name: '原料B', num: 50 },
              { id: 3, name: '原料C', num: 50 },
              { id: 4, name: '原料D', num: 50 }
            ]
          },
          {
            id: 4,
            name: '产品D(L15）',
            boms: [
              { id: 1, name: '原料A', num: 50 },
              { id: 2, name: '原料B', num: 50 },
              { id: 3, name: '原料C', num: 50 }
            ]
          }
        ]
      };
    },
    methods: {
      // 跳转到配送管理页面
      turn(url) {
        this.$router.push({ path: url });
      },
      toggleShow() {
        this.state.taskOutVisible = false;
      },
      taskOut(bomId, taskOutPositionName) {
        console.log('taskOut>>>>>>>>>>>', bomId);
        this.taskOutBomId = bomId;
        this.taskOutPositionName = taskOutPositionName;
        this.state.taskOutVisible = true;
      }
    }
  };
</script>
