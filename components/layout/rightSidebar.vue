<!--
 * @Author: Shaoli
 * @Date: 2023-02-12 12:31:28
 * @LastEditors: Shaoli
 * @LastEditTime: 2023-02-26 17:44:03
 * @Description: 右侧footer
-->
<template>
  <div class="footer">
    <div class="footer-fixed">
      <div v-if="state.noticeInfo?.content" class="notice">
        <div>公告</div>
        <div class="content">{{ state.noticeInfo?.content }}</div>
      </div>

      <div class="web-master">
        <a-avatar :src="state.webMasterInfo.avatar" :size='64'/>
        <div>
          <div class="name">{{ state.webMasterInfo.nicker }}</div>
          <div class="intro">{{ state.webMasterInfo.intro }}</div>
        </div>
      </div>

      <div class="tags">
        <div class="title">热门搜索</div>
        <div class="tag-list">
          <nuxt-link
            v-for="item in state.tags"
            :key="item"
            :to="`/tag/${item}`"
            class="item"
            >{{ item }}</nuxt-link
          >
        </div>
      </div>
      <MdCatalog editor-id="preview-only" :scroll-element="scrollElement" />

      <div class="corp-links">
        <a
          class="friend-link"
          v-for="item in links"
          target="_blank"
          rel="nofollow"
          :href="item.url"
          :key="item.id"
          >{{ item.title }}</a
        >
      </div>
      <div>
        <a
          target="_blank"
          rel="nofollow"
          href="https://beian.miit.gov.cn"
          class="beian"
          >{{ state.icp }}</a
        >
        <div>{{ state.copyright }}</div>
      </div>
    </div>
  </div>
</template>

<script lang="ts" setup>
import { MdCatalog } from 'md-editor-v3'
import request from '@/utils/request'
import { useWebMasterStore } from '@/stores';
import { WebMaster } from '~/stores/types';
let scrollElement: HTMLElement | undefined = undefined
if (process.client) {
  scrollElement = document.documentElement
}

const getList = async () => {
  const { data }: any = await request.post('/site/getFriendLinkList')
  links.value = data?.list || []
}
const links = ref<Record<string, string>[]>([])

const state = reactive({
  intro: '',
  icp: '',
  copyright: '',
  tags: [],
  noticeInfo: {
    content: ''
  },
  webMasterInfo: <WebMaster> {
  }
})
const getDetail = async () => {
  const { data }: any = await request.post('/site/getSiteInfo')
  state.copyright = data?.copyright || ''
  state.intro = data?.intro || ''
  state.icp = data?.icp || ''
}

const getTags = async () => {
  const { data }: any = await request.post('/blog/getAllTags')
  state.tags = data || []
}
const getNoice = async () => {
  const { data }: any = await request.post('/site/getNoticeList')
  state.noticeInfo = data?.list ? data?.list[0] : null
}

// 获取站长信息并缓存
const webMasterStore = useWebMasterStore()
const getWebmasterInfo = async () => {
  const { data } = await request.post('/site/getWebmasterInfo')
  state.webMasterInfo = data || {}
  webMasterStore.saveInfo(data)
}

getNoice()
getDetail()
getTags()
getList()
getWebmasterInfo()
</script>

<style lang="less" scoped>
.beian {
  display: block;
  line-height: 17px;
  margin: 6px 0;
}
:deep(.md-editor-catalog) {
  color: #67788a;
}
.footer {
  width: 300px;
  border-left: 1px solid #ececec;
  padding-left: 20px;
  flex-shrink: 0;
}
.footer-fixed {
  width: 300px;
  padding: 24px 0;
  position: fixed;
  top: 60px;
  
  .web-master {
    display: flex;
    gap: 8px;
    .name {
      font-size: 20px;
      color: #000;
      margin-bottom: 8px;
    }
    .intro {
      font-size: 13px;
      line-height: 162.2%;
      text-align: justify;
      color: #21293c;
      margin-top: 12px;
    }
  }

  .corp-links {
    margin-top: 48px;
    color: #67788a;
    font-size: 12px;
    a {
      color: #67788a;
      &:hover {
        color: #f92741;
      }
    }
    .friend-link {
      margin-right: 8px;
    }
  }
  .tags {
    margin: 30px 0 0;
    .title {
      font-size: 19px;
      line-height: 27px;
      color: #21293c;
      margin-bottom: 20px;
    }
    .tag-list {
      display: flex;
      flex-wrap: wrap;
    }
    .item {
      padding: 10px 16px;
      font-size: 14px;
      color: #4b587c;
      margin: 0 8px 8px 0;
      background: #f2f6f9;
      border-radius: 6px;
    }
  }
}
.notice {
  background-color: rgba(255, 149, 0, 0.1);
  padding: 20px;
  font-size: 16px;
  margin-bottom: 20px;
  .content {
    margin-top: 8px;
    font-size: 12px;
  }
}
</style>
