/**
 * Created by flyye on 2017/9/25.
 * @providesModule CommonImageBuilder
 */

/**
 * @param imageUrl
 */
function getImage(imageUrl) {
  switch (imageUrl) {
    case 'common_follow_false':
      return require('../img/abs_roleselection_btn_collect_default.png');
    case 'common_follow_true':
      return require('../img/abs_roleselection_btn_collect_selected.png');
    case 'common_btn_back':
      return require('../img/abs_roleselection_btn_back_default.png');
    case 'common_right_arrow':
      return require('../img/abs_square_btn_toview_default.png');
    case 'common_btn_more_gray':
      return require('../img/abs_throughthecode_btn_more_default.png');
    case 'common_btn_more_blue':
      return require('../img/abs_square_btn_more_default.png');
    case 'common_heart_gray':
      return require('../img/abs_generalize_btn_thumbsup_default.png');
    case 'common_heart_red':
      return require('../img/abs_generalize_btn_thumbsup_selected.png');
    case 'common_add':
      return require('../img/abs_find_btn_addto_default.png');
    case 'common_btn_green':
      return require('../img/abs_therrbody_btn_more_default.png');
    case 'common_like_true':
      return require('../img/abs_dynamic_btn_like_selected.png');
    case 'common_like_false':
      return require('../img/abs_dynamic_btn_like_default.png');
    case 'common_add_follow':
      return require('../img/abs_generalize_btn_follow_default.png');
    case 'common_focus_true':
      return require('../img/abs_contactperson_btn_attention_selected.png');
    case 'common_menu':
      return require('../img/abs_home_btn_more_default.png');
    default:
      return;
  }
}

module.exports = {
  getImage
};
