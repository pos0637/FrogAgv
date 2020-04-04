<template>
  <div class="dialog-height agv-dialog">
    <el-form :model="info" label-position="left" label-width="200px" ref="editForm">
      <el-row>
        <el-form-item label="名称：" prop="name">
          <el-input v-model="info.name" readonly disabled></el-input>
        </el-form-item>
      </el-row>
      <el-row>
        <el-form-item label="单位：" prop="num">
          <el-input v-model="info.unit" readonly disabled></el-input>
        </el-form-item>
      </el-row>
      <el-row>
        <el-form-item label="数量：" prop="done">
          <el-input v-model="info.num" readonly disabled></el-input>
        </el-form-item>
      </el-row>
      <el-row>
        <el-form-item label="产线：" prop="done">
          <el-select v-model="info.line" placeholder="请选择产线">
            <el-option :label="item.name" :value="item.id" v-for="(item) in lines" :key="item.id"></el-option>
          </el-select>
        </el-form-item>
      </el-row>
    </el-form>

    <div slot="footer" class="dialog-footer" align="center">
      <el-button @click="toggleShow" class="dialog-cancel-btn">{{$t('table.cancel')}}</el-button>
      <el-button
        type="primary"
        @click="updateData"
        class="dialog-update-btn"
      >{{$t('table.confirm')}}</el-button>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'editBom',
    data() {
      return {
        info: {
          name: '原料A',
          num: 50,
          unit: '个'
        },
        lines: [
          { id: 1, name: '产线1' },
          { id: 2, name: '产线2' },
          { id: 3, name: '产线3' },
          { id: 4, name: '产线4' },
          { id: 5, name: '产线5' }
        ]
      }
  },
    created() {
      this.loadingInfo()
  },
    props: {
      id: [String, Number]
    },
    methods: {
      loadingInfo() {},
      // 弹出框标志变化
      toggleShow() {
        this.$emit('toggleShow')
      },
      // 修改信息
      updateData() {
        console.log('updateData>>>>>>>>>>>')
        this.$emit('toggleShow')
      }
    }
  }
</script>