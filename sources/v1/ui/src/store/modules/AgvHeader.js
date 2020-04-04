const AgvHeader = {
  state: {
    title: '青蛙AGV系统'
  },
  mutations: {
    UPDATE_TITLE: (state, title) => {
      state.title = title
    }
  },
  actions: {
    updateTitle({ commit, state }, title) {
      console.log('updateTitle>>>>>>>>>>>>>>>>>>>>>>')
      commit('UPDATE_TITLE', title)
    }
  }
}

export default AgvHeader
