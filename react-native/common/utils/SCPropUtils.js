/**
 * Created by flyye on 2017/10/23.
 *
 * @providesModule SCPropUtils
 */
var Platform = require('Platform');

function getPropsFromNative(props) {
  return typeof(props.screenProps) === 'undefined' // this.props.screenProps 来在每个页面中访问该全局属性
    ? ''
    : JSON.parse(props.screenProps); // JSON.parse() 方法用于将一个 JSON 字符串转换为对象
}

module.exports = {
  getPropsFromNative
};
