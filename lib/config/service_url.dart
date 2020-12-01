const serviceUrl = 'https://apitest.hexiaoxiang.com/';
//const serviceUrl= 'http://test.baixingliangfan.cn/baixing/';
const Map servicePath = {
  'homeCategoryPageContext':
      serviceUrl + 'oursequality/api/v1/category/list?last_index=0&platform=0',
  'homeBannerPageContext': serviceUrl + 'advertisement/ad/list',
  'homePageRecommend': serviceUrl +
      '/coursequality/api/v1/information/flow/recommend?last_index=0&platform=0', //首页课程推荐
  'getCategory': serviceUrl + 'wxmini/getCategory', //商品类别信息
  'getMallGoods': serviceUrl + 'wxmini/getMallGoods', //商品分类的商品列表
  'getGoodDetailById': serviceUrl + 'wxmini/getGoodDetailById', //商品详细信息列表
};

//
