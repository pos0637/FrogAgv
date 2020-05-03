const AgvHeader = {
  state: {
    title: '青蛙AGV系统',
    needLogin: true
  },
  mutations: {
    UPDATE_TITLE: (state, title) => {
      state.title = title
    },
    UPDATE_NEED_LOGIN: (state, needLogin) => {
      state.needLogin = needLogin
    }
  },
  actions: {
    updateTitle({ commit, state }, title) {
      commit('UPDATE_TITLE', title)
    },
    updateNeedLogin({ commit, state }, needLogin) {
      commit('UPDATE_NEED_LOGIN', needLogin)
    }
  }
}

export default AgvHeader
