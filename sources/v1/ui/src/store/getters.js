const getters = {
  sidebar: state => state.app.sidebar,
  language: state => state.app.language,
  device: state => state.app.device,
  visitedViews: state => state.tagsView.visitedViews,
  cachedViews: state => state.tagsView.cachedViews,
  token: state => state.user.token,
  avatar: state => state.user.avatar,
  name: state => state.user.name,
  introduction: state => state.user.introduction,
  status: state => state.user.status,
  roles: state => state.user.roles,
  setting: state => state.user.setting,
  permission_routers: state => state.permission.routers,
  addRouters: state => state.permission.addRouters,
  errorLogs: state => state.errorLog.logs,
  areas: state => state.area.areas,
  areaList: state => state.area.areaList,
  resources: state => state.resource.resources,
  dictGroups: state => state.dict.dictGroups,
  departments: state => state.department.departments,
  positions: state => state.position.positions,
  projects: state => state.project.projects,
  tasks: state => state.task.tasks,
  types: state => state.type.types,
  title: state => state.AgvHeader.title,
  needLoign: state => state.AgvHeader.needLoign
}
export default getters
