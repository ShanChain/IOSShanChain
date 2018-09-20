/**
 * Created by flyye on 21/9/17.
 */

/**
 * @param imageUrl
 */
function getImage(imageUrl) {
  switch (imageUrl) {
    case 'follow_false':
      return require('../img/abs_roleselection_btn_collect_default.png');
    case 'follow_true':
      return require('../img/abs_roleselection_btn_collect_selected.png');
    case 'btn_back':
      return require('../img/abs_roleselection_btn_back_default.png');
    case 'cross_rule':
      return require('../img/abs_square_btn_code_default.png');
    case 'drama':
      return require('../img/abs_square_btn_drama_default.png');
    case 'long_text':
      return require('../img/abs_square_btn_longtext_default.png');
    case 'right_arrow':
      return require('../img/abs_square_btn_toview_default.png');
    case 'btn_more_gray':
      return require('../img/abs_throughthecode_btn_more_default.png');
    case 'btn_more_blue':
      return require('../img/abs_square_btn_more_default.png');
    case 'heart_gray':
      return require('../img/abs_generalize_btn_thumbsup_default.png');
    case 'heart_red':
      return require('../img/abs_generalize_btn_thumbsup_selected.png');
    case 'sq_background':
      return require('../img/sq_background.png');
    case 'topic1':
      return require('../img/topic1.png');
    case 'topic2':
      return require('../img/topic2.png');
    case 'topic3':
      return require('../img/topc3.png');
    case 'check_true':
      return require('../img/abs_at_btn_selected_selected.png');
    case 'check_false':
      return require('../img/abs_at_btn_selected_unselected.png');
    case 'check_gray':
      return require('../img/abs_management_btn_select_default.png');
    default:
      return;
  }
}

module.exports = {
  getImage
};
