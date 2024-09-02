/*
 * @Author: Shaoli
 * @Date: 2023-01-08 22:35:28
 * @LastEditors: Shaoli
 * @LastEditTime: 2023-02-19 14:36:18
 * @Description: 请填写文件描述
 */
import { defineStore } from 'pinia'
import { WebMaster } from './types'

export const useCommon = defineStore('common', {
  state: () => ({
    currentSectionId: ''
  }),
  actions: {
    setCurrentSectionId(v: string) {
      this.currentSectionId = v
    }
  }
})


export const useWebMasterStore = defineStore('webMaster', {
  state: (): WebMaster => ({
    avatar: '',
    nicker: '',
    intro: '',
    gitee: '',
    github: '',
  }),

  actions: {
    persist(webMaster: WebMaster) {
      this.$patch(webMaster)
    }
  },

  getters: {
    getInfo(): WebMaster {
      return this || {}
    }
  }
})