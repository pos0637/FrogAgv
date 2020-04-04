export default {
  taskState: [
    { value: 0, label: '未开始' },
    { value: 1, label: '进行中' },
    { value: 2, label: '测试中' },
    { value: 3, label: '验收中' },
    { value: 99, label: '挂起' },
    { value: 100, label: '作废' },
    { value: 6, label: '结束' }
  ],
  everyDayWorkHours: 8,
  projectState: [
    { value: 0, label: '需求收集中' },
    { value: 1, label: '评审中' },
    { value: 2, label: '等待执行' },
    { value: 3, label: '进行中' },
    { value: 4, label: '验收中' },
    { value: 99, label: '挂起' },
    { value: 100, label: '作废' },
    { value: 7, label: '结束' },
    { value: 9, label: '未开始' }
  ],
  projectAuth: {
    all: 'pms_all_project_manage',
    create: 'pms_project_create',
    edit: 'pms_project_edit',
    delete: 'pms_project_delete',
    search: 'pms_project_search',
    export: 'pms_project_export'
  },
  userIcon: '/resources/header.jpg',
  busState: {
    run: 0,
    stop: 1
  },
  hoistState: {
    offline: 0,
    disable: 1,
    lock: 2,
    standby: 3,
    run: 4
  },
  branchState: {
    offline: 0,
    stop: 1,
    run: 2
  }
}
