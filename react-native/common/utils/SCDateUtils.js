/**
 *@providesModule SCDateUtils
 *
 * Created by flyye on 2017/11/01.
 */
var SCDateUtils = {

  getContentTimeFormat: function(timeStamp) {
    console.log(timeStamp);
    var time = new Date(timeStamp);
    time.setTime(timeStamp);
    console.log(time);
    var y = time.getFullYear();
    var m = time.getMonth() + 1;
    var d = time.getDate();
    var h = time.getHours();
    var mm = time.getMinutes();
    var s = time.getSeconds();

    var nowTime = new Date();
    var nowy = nowTime.getFullYear();
    var nowm = nowTime.getMonth() + 1;
    var nowd = nowTime.getDate();
    var nowh = nowTime.getHours();
    var nowmm = nowTime.getMinutes();
    var nows = nowTime.getSeconds();
    if (nowy != y) {
      return y + '年' + (
        m < 10
        ? '0' + m
        : m) + '月' + (
        d < 10
        ? '0' + d
        : d) + '日';
    } else if (nowm != m) {
      return (
        m < 10
        ? '0' + m
        : m) + '月' + (
        d < 10
        ? '0' + d
        : d) + '日';
    } else if (nowd != d) {
      return (
        m < 10
        ? '0' + m
        : m) + '月' + (
        d < 10
        ? '0' + d
        : d) + '日';
    } else if (nowh != h) {
      let hour = Math.floor(((nowh * 60 + nowm) - (h * 60 + mm)) / 60);
      let minute = Math.floor(((nowh * 60 + nowm) - (h * 60 + mm)) % 60);
      if (hour == 0) {
        return minute + '分前';
      } else {
        return hour + '时' + minute + '分前';
      }

    } else {
      let minute = Math.floor(((nowmm * 60 + nows) - (mm * 60 + s)) / 60);
      let second = Math.floor(((nowmm * 60 + nows) - (mm * 60 + s)) % 60);
      if (minute == 0) {
        return second + '秒前';
      } else {
        return minute + '分' + second + '秒前';
      }
    }
  }
}
module.exports = SCDateUtils;
