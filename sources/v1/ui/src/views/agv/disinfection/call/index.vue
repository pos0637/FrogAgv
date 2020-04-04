<template>
  <div class="flex-box flex-direction-column" style="height:100%">
    <div class="content flex-box fillParent">
      <!-- 左边菜单 -->
      <div class="left-menu">
        <div
          class="menu-item flex-box flex-justify-content-center flex-align-items-center"
          @click="turn('/disinfection/task')"
        >配货任务</div>
        <div
          class="menu-item current-menu flex-box flex-justify-content-center flex-align-items-center"
        >叫料</div>
        <div
          class="menu-item flex-box flex-justify-content-center flex-align-items-center"
          @click="turn('/disinfection/call/history')"
        >
          叫料历史
          <span class="pick">{{this.num}}</span>
        </div>
      </div>
      <!-- 右边内容 -->
      <div
        class="flex-box flex-direction-column"
        style="width:100%;margin-left:10px;margin-right:20px;"
      >
        <!-- 表头内容 -->
        <div class="flex-box data-header-content flex-align-items-center" style="width:100%;">
          <div class="data-header-name">名称</div>
          <div class="data-header-num">需求数量</div>
          <div class="data-header-done">状态</div>
          <div class="data-header-operation"></div>
        </div>
        <!-- 表格内容 -->
        <div class="flex-box data-content flex-direction-column" style="width:100%;">
          <div v-for="(item) in cData" :key="item.id">
            <div class="data-content-produce-row flex-box flex-align-items-center">
              <div class="data-name">{{item.name}}</div>
              <div class="bom-num"></div>
              <div class="bom-done"></div>
              <div class="data-content-produce-operation flex-box flex-align-items-center"></div>
            </div>
            <div class="data-wave" v-for="(wave,index) in item.waves" :key="wave.id">
              <div class="data-content-wave-row flex-box flex-align-items-center">
                <div class="wave-name">{{'波次' + (index + 1)}}</div>
                <div class="bom-num"></div>
                <div class="bom-done"></div>
                <div class="data-content-wave-operation flex-box flex-align-items-center"></div>
              </div>
              <div v-for="(bom) in wave.boms" :key="bom.id" class="flex-box data-content-row">
                <div
                  class="bom-name flex-box flex-align-items-center flex-justify-content-center"
                >{{bom.name}}</div>
                <div
                  class="bom-num flex-box flex-align-items-center flex-justify-content-center"
                >{{bom.num}}</div>
                <div class="bom-done flex-box flex-align-items-center flex-justify-content-center">
                  <span v-if="bom.status">已叫料</span>
                  <span v-else>未叫料</span>
                </div>
                <div class="data-content-operation flex-box flex-align-items-center">
                  <div class="bom-delete" @click="callBom(bom.id)" v-if="!bom.status">叫料</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import '../../product/home/home.scss';
  import './call.scss';

  export default {
    name: 'call',
    components: {},
    created() {
      this.$store.dispatch('updateTitle', '消毒间叫料');
    },
    data() {
      return {
        num: '99+',
        state: {},
        cData: [
          {
            id: 1,
            name: '产品A（L15）',
            waves: [
              {
                id: 1,
                status: true,
                boms: [
                  { id: 1, name: '原料A', num: 50, status: true },
                  { id: 2, name: '原料B', num: 50, status: true },
                  { id: 3, name: '原料C', num: 50, status: true }
                ]
              },
              {
                id: 2,
                status: true,
                boms: [
                  { id: 1, name: '原料A', num: 50, status: false },
                  { id: 2, name: '原料B', num: 50, status: true }
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
                status: false,
                boms: [
                  { id: 1, name: '原料A', num: 50, status: false },
                  { id: 2, name: '原料B', num: 50, status: false }
                ]
              }
            ]
          }
        ]
      };
    },
    methods: {
      // 跳转
      turn(url) {
        this.$router.push({ path: url });
      },
      toggleShow() {},
      callBom(bomId) {
        console.log('callBom>>>>>>>>>>>>', bomId);
      }
    }
  };
</script>
