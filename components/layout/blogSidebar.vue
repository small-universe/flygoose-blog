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

      <div class="web-master">
        <a-avatar :src="webMasterInfo.avatar" :size='64'/>
        <div>
          <div class="name">{{ webMasterInfo.nicker }}</div>
          <div class="intro">{{ webMasterInfo.intro }}</div>
        </div>
      </div>

      <div class="title">索引目录</div>
      <MdCatalog editor-id="preview-only" :scroll-element="scrollElement" />
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
    </div>
  </div>
</template>

<script lang="ts" setup>
import { MdCatalog } from 'md-editor-v3'
import request from '@/utils/request'
import { useWebMasterStore } from '@/stores';

let scrollElement: HTMLElement | undefined = undefined
if (process.client) {
  scrollElement = document.documentElement
}

const webMasterStore = useWebMasterStore()
const webMasterInfo = reactive(webMasterStore.getInfo)

const state = reactive({
  intro: '',
  icp: '',
  copyright: '',
  tags: []
})

const getTags = async () => {
  const { data }: any = await request.post('/blog/getAllTags')
  state.tags = data || []
}
getTags()
</script>

<style lang="less" scoped>
.intro {
  margin: 12px 0 44px 0;
  color: #67788a;
  font-size: 15px;
}
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
img {
  width: 56px;
  height: 56px;
  border-radius: 50%;
}
:deep(.md-editor-catalog) {
  color: #67788a;
}
.footer {
  width: 330px;
  border-left: 1px solid #ececec;
  padding-left: 20px;
  flex-shrink: 0;
}
.footer-fixed {
  width: 300px;
  padding: 32px 0;
  position: fixed;
  top: 60px;
  .logo {
    height: 36px;
  }
  .intro {
    font-size: 13px;
    line-height: 162.2%;
    text-align: justify;
    color: #21293c;
    margin-top: 12px;
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
  .title {
    font-size: 19px;
    line-height: 27px;
    color: #21293c;
    margin-bottom: 20px;
  }
  .tags {
    margin: 30px 0 0;

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
</style>
