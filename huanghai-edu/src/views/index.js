//批量导入导出
var files = require.context('./', true, /index.vue$/);
let views = {};
files.keys().forEach(filePath =>{
        let key = filePath.match(/.*\/(.*)\/index.vue$/)[1];
        views[key] = files(filePath).default;
});
export default views;