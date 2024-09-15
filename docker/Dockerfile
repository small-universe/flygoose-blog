# 参考https://juejin.cn/post/7380545407728844827


FROM node:19.9.0 as builder
# 设置 npm registry 环境变量
ENV NPM_CONFIG_REGISTRY=https://registry.npmmirror.com/
# 取消 ssl 验证 解决报错：npm ERR! code UNABLE_TO_VERIFY_LEAF_SIGNATURE
ENV NPM_CONFIG_STRICT_SSL=false
ENV NPM_CONFIG_LEGACY_PEER_DEPS=true
COPY . /flygoose-blog-web
WORKDIR /flygoose-blog-web
RUN npm install yarn
RUN npm cache clean --force
RUN yarn install && yarn build

# 构建最终的镜像
FROM node:19.9.0-alpine as runner
ENV NPM_CONFIG_REGISTRY=https://registry.npmmirror.com/

WORKDIR /apps/flygoose-blog-web

COPY ./docker/nginx.conf /etc/nginx/http.d/default.conf
COPY ./docker/env.update.sh .
COPY ./docker/.env .
COPY --from=builder /flygoose-blog-web/nuxt.config.ts .
COPY --from=builder /flygoose-blog-web/package.json .
COPY --from=builder /flygoose-blog-web/pm2.config.js .
COPY --from=builder /flygoose-blog-web/.nuxt ./.nuxt
COPY --from=builder /flygoose-blog-web/.output ./.output

EXPOSE 80

# 安装nginx、pm2和bash
RUN apk add --update --no-cache nginx \
    && npm install -g pm2 \
    && apk add --no-cache bash \
    && sed -i 's/\r$//' ./env.update.sh \
    && chmod +x ./env.update.sh

# 更新访问地址、启动nginx、使用pm2启动项目
CMD ["sh", "-c", "./env.update.sh && nginx && pm2-runtime start pm2.config.js; pm2 list"]
