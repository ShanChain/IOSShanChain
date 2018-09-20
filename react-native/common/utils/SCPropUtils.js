/**
 * Created by flyye on 2017/10/23.
 *
 * @providesModule SCPropUtils
 */
var Platform = require('Platform');

function getPropsFromNative(props) {
  return typeof(props.screenProps) === 'undefined'
    ? ''
    : JSON.parse(props.screenProps);
}

module.exports = {
  getPropsFromNative
};
