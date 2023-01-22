# syntax=docker/dockerfile:1

ARG BUILDPLATFORM="linux/amd64"

FROM --platform=${BUILDPLATFORM} alpine:3.17 AS build

ARG CACHEBUST

# hadolint ignore=DL3020
ADD ${CACHEBUST} /.git-hashref

SHELL ["/bin/ash", "-eufo", "pipefail", "-c"]

RUN apk --no-cache add \
    curl=~7.87.0 \
    sed=~4.9 \
    git=~2.38 \
    # tzdata=~2022f \
    # go=~1.19.5 \
    make=~4.3 \
    bash=~5.2.15 \
    ca-certificates=~20220614 && \
    sync

ARG GIT_CLONE_FLAGS
ARG PACKAGE_NAME
ARG PACKAGE_GIT_REF
ARG PACKAGE_VERSION
ARG PACKAGE_VERSION_PREFIX
ARG PACKAGE_DNS_SERVER
ARG PACKAGE_DNS_CONFIG_TYPE
ARG PACKAGE_URL
ARG PACKAGE_SOURCE_URL
ARG PACKAGE_HEAD_URL
ARG PACKAGE_HEAD=false

# hadolint ignore=SC2015
RUN { [ -n "${PACKAGE_VERSION_PREFIX}" ] && [ -n "${PACKAGE_VERSION}" ] && PACKAGE_VERSION="${PACKAGE_VERSION_PREFIX}${PACKAGE_VERSION}" || true; } && \
    mkdir -p "/usr/local/src/${PACKAGE_NAME}" && \
    [ -n "${PACKAGE_NAME}" ] && \
    { { [ -n "${PACKAGE_HEAD_URL}" ] && \
      { echo "Git clone ${PACKAGE_HEAD_URL} ..." && git clone ${GIT_CLONE_FLAGS} "${PACKAGE_HEAD_URL}" "/usr/local/src/${PACKAGE_NAME}" && \
        { [ -n "${PACKAGE_VERSION}" ] && [ "${PACKAGE_HEAD}" != true ] && [ "${PACKAGE_HEAD}" != "on" ] && [ "${PACKAGE_HEAD}" != "1" ] && \
          { { { [ -n "${PACKAGE_VERSION}" ] && [ "${PACKAGE_HEAD}" != true ] && [ "${PACKAGE_HEAD}" != "on" ] && [ "${PACKAGE_HEAD}" != "1" ] && \
                echo "Git checkout to tags/${PACKAGE_VERSION}" && git -C "/usr/local/src/${PACKAGE_NAME}" checkout tags/${PACKAGE_VERSION}; } && \
              { [ -n "${PACKAGE_VERSION}" ] && [ "${PACKAGE_HEAD}" != true ] && [ "${PACKAGE_HEAD}" != "on" ] && [ "${PACKAGE_HEAD}" != "1" ]; }; } || \
            { { ! { [ -n "${PACKAGE_VERSION}" ] && [ "${PACKAGE_HEAD}" != true ] && [ "${PACKAGE_HEAD}" != "on" ] && [ "${PACKAGE_HEAD}" != "1" ] && \
                echo "Git checkout to tags/${PACKAGE_VERSION}" && git -C "/usr/local/src/${PACKAGE_NAME}" checkout tags/${PACKAGE_VERSION}; }; } && \
              { ! { [ -n "${PACKAGE_VERSION}" ] && [ "${PACKAGE_HEAD}" != true ] && [ "${PACKAGE_HEAD}" != "on" ] && [ "${PACKAGE_HEAD}" != "1" ]; }; }; }; }; } || \
        { [ -n "${PACKAGE_GIT_REF}" ] && [ "${PACKAGE_HEAD}" != true ] && [ "${PACKAGE_HEAD}" != "on" ] && [ "${PACKAGE_HEAD}" != "1" ] && \
          { { { [ -n "${PACKAGE_GIT_REF}" ] && [ "${PACKAGE_HEAD}" != true ] && [ "${PACKAGE_HEAD}" != "on" ] && [ "${PACKAGE_HEAD}" != "1" ] && \
                echo "Git checkout to refs/${PACKAGE_GIT_REF}" && git -C "/usr/local/src/${PACKAGE_NAME}" checkout ${PACKAGE_GIT_REF}; } && \
              { [ -n "${PACKAGE_GIT_REF}" ] && [ "${PACKAGE_HEAD}" != true ] && [ "${PACKAGE_HEAD}" != "on" ] && [ "${PACKAGE_HEAD}" != "1" ]; }; } || \
            { { ! { [ -n "${PACKAGE_GIT_REF}" ] && [ "${PACKAGE_HEAD}" != true ] && [ "${PACKAGE_HEAD}" != "on" ] && [ "${PACKAGE_HEAD}" != "1" ] && \
                echo "Git checkout to refs/${PACKAGE_GIT_REF}" && git -C "/usr/local/src/${PACKAGE_NAME}" checkout ${PACKAGE_GIT_REF}; }; } && \
              { ! { [ -n "${PACKAGE_GIT_REF}" ] && [ "${PACKAGE_HEAD}" != true ] && [ "${PACKAGE_HEAD}" != "on" ] && [ "${PACKAGE_HEAD}" != "1" ]; }; }; }; }; }; }; } || \
      { [ -n "${PACKAGE_SOURCE_URL}" ] && echo "curl download ${PACKAGE_SOURCE_URL}" && curl -fsSL "${PACKAGE_SOURCE_URL}" | \
        tar -zxC "/usr/local/src/${PACKAGE_NAME}" --strip 1; } || \
      { [ -n "${PACKAGE_URL}" ] && [ -n "${PACKAGE_GIT_REF}" ] && \
        echo "curl download ${PACKAGE_URL}/archive/${PACKAGE_GIT_REF}.tar.gz" && curl -fsSL "${PACKAGE_URL}/archive/${PACKAGE_GIT_REF}.tar.gz" | \
        tar -zxC "/usr/local/src/${PACKAGE_NAME}" --strip 1; }; } || false

WORKDIR /usr/local/src/${PACKAGE_NAME}

RUN make SERVER=${PACKAGE_DNS_SERVER} ${PACKAGE_DNS_CONFIG_TYPE}


FROM --platform=${BUILDPLATFORM} scratch AS artifact

ARG PACKAGE_NAME
ARG PACKAGE_DNS_CONFIG_NAME

COPY --from=build /usr/local/src/${PACKAGE_NAME}/${PACKAGE_DNS_CONFIG_NAME} /
