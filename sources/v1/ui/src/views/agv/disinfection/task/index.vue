<template>
  <div class="flex-box flex-direction-column" style="height:100%">
    <div class="content flex-box fillParent">
      <!-- 左边菜单 -->
      <div class="left-menu">
        <div
          class="menu-item current-menu flex-box flex-justify-content-center flex-align-items-center"
        >配货任务</div>
        <div
          class="menu-item flex-box flex-justify-content-center flex-align-items-center"
          @click="turn('/disinfection/call')"
        >叫料</div>
        <div
          class="menu-item flex-box flex-justify-content-center flex-align-items-center"
          @click="turn('/disinfection/call/history')"
        >叫料历史</div>
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
            <div v-for="(item) in sites" :key="item.id">
              <div @click="taskOut(item)" class="pointer site-item">
                <div class="position position-pointer" v-if="item.stockUpRecordId">{{item.bomName}}</div>
                <div class="position" v-else></div>
                <div class="site-item-name">{{item.name}}</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <el-dialog
      v-if="state.taskOutVisible"
      :visible.sync="state.taskOutVisible"
      :title="taskOutPositionName"
      class="dialog-transfer"
    >
      <TaskOut :bom="taskOutBom" @toggleShow="toggleShow"></TaskOut>
    </el-dialog>
  </div>
</template>

<script>
  import '../../product/home/home.scss'
import './task.scss'
import TaskOut from './taskOut'
import request from '@/utils/request'
import Constants from '@/utils/constants'
import { isEmpty } from '@/utils/helper'
import { Loading } from 'element-ui'

export default {
    name: 'home',
    components: { TaskOut },
    created() {
      this.loadingInfo()
  },
    data() {
      return {
        state: {
          taskOutVisible: false
        },
        // 加载对象
        load: null,
        sites: [],
        taskOutPositionName: '',
        taskOutBom: null,
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
          { id: 14, name: '库位4', bomName: '' }
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
      }
  },
    methods: {
      loadingInfo() {
        this.$store.dispatch('updateTitle', '消毒间配货任务')
        this.getSites()
      },
      // 跳转到配送管理页面
      turn(url) {
        this.$router.push({ path: url })
      },
      toggleShow() {
        this.state.taskOutVisible = false
      },
      taskOut(bom) {
        console.log('taskOut>>>>>>>>>>>', bom)
        this.taskOutBom = bom
        this.taskOutPositionName = bom.name
        this.state.taskOutVisible = true
      },
      getSites() {
        request({
          url: '/agv/sites',
          method: 'get',
          params: {
            type: 4
          }
        })
          .then(response => {
            console.log('getSites*****:', response)
            if (response.errno === 0) {
              if (!isEmpty(response.data)) {
                this.sites = response.data
              }
              // 如果遮罩层存在
              if (!isEmpty(this.load)) {
                this.load.close()
              }
            }
          })
          .catch(_ => {
            this.load = this.showErrorMessage('服务器请求失败')
          })
      },
      // 用遮罩层显示错误信息
      showErrorMessage(message) {
        const options = {
          lock: true,
          fullscreen: true,
          text: message,
          spinner: '',
          background: 'rgba(0, 0, 0, 0.7)'
        }
        return Loading.service(options)
      }
    }
  }
</script>
