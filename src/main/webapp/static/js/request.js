axios.defaults.withCredentials = true;
const encodeURIComponent = data => {
  const params = []
  for (const key of Object.keys(data)) {
    if (typeof data[key] === 'boolean' 
      || typeof data[key] === 'string' 
      || typeof data[key] === 'number'
    ) {
      params.push(key + '=' + data[key])
    } else {
      params.push(key + '=' + JSON.stringify(data[key]))
    }
  }
  return encodeURI(params.join('&'))
}
class HttpRequest {
  constructor() {
    this.withCredentials = true
  }

  getInsideConfig() {
    return ({
      method: 'get',
      headers: {
        'Content-Type': 'application/json'
      }
    });
  }

  //拦截器
  interceptors(instance, url) {
    //请求拦截器
    instance.interceptors.request.use(
      config => {  
        return config
      },
      error => Promise.reject(error)
    )

    //响应拦截器
    instance.interceptors.response.use(res => {
      if (res.data.code === 90001) {
        window.localStorage.setItem("sid", "")
        window.location.reload()
      } else if (res.data.code === 200) {
        return res.data.data
      } else {
        const { code, message, result } = res.data;
        return Promise.reject({
          code,
          message,
          result,
        })
      }
    }, error => {
      console.log(`请求失败:${error}`)
      try{
        if(error == 'Cancel') return;
        const { status } = error.response;
        const message = error.message;
        Message.error(error.message)
        return Promise.reject({
          status,
          message
        })
      }catch(e){}
    })
  }

  request(options) {
    const instance = axios.create()
    options = Object.assign(this.getInsideConfig(), options)
    this.interceptors(instance, options.url)
    return instance(options)
  }
}

const fetch = new HttpRequest()

const axiosGet = (url, params, options) => fetch.request({
  url,
  params,
  ...options
});

const axiosPost = (url, data, options) => fetch.request({
  url,
  data: encodeURIComponent(data),
  method: 'post',
  headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
  ...options,
});

const axiosPostJSON = (url, data, options) => fetch.request({
  url,
  data,
  method: 'post',
  headers: { 'Content-Type': 'application/json' },
  ...options,
});

const axiosUploadFile = (url, data, options) => fetch.request({
  url,
  data,
  method: 'POST',
  processData: false,
  contentType: false,
  cache: false,
  mimeType: "multipart/form-data",
  ...options,
});
