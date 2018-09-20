/**
 * Created by flyye on 21/9/17.
 */

/**
 * @param imageUrl
 */
function getImage(imageUrl) {
  switch (imageUrl) {
    case 'heart_red':
      return require('../img/abs_generalize_btn_thumbsup_selected.png');
    case 'mine_background':
      return require('../img/mine_background.png');
    case 'my_role':
      return require('../img/abs_mine_btn_character_default.png');
    case 'my_comment':
      return require('../img/abs_mine_btn_comment_default.png');
    case 'my_data':
      return require('../img/abs_mine_btn_data_default.png');
    case 'my_dialogue':
      return require('../img/abs_mine_btn_dialogue_default.png');
    case 'my_draftbox':
      return require('../img/abs_mine_btn_draftbox_default.png');
    case 'my_drama':
      return require('../img/abs_mine_btn_drama_default.png');
    case 'my_long_text':
      return require('../img/abs_mine_btn_longtext_default.png');
    case 'modify_btn':
      return require('../img/abs_mine_btn_modify_default.png');
    case 'setting_btn':
      return require('../img/abs_mine_btn_setup_default.png');
    case 'story_btn':
      return require('../img/abs_mine_btn_story_default.png');
    case 'role_switch':
      return require('../img/abs_mine_btn_switch_default.png');
    case 'my_thumbsup':
      return require('../img/abs_mine_btn_thumbsup_default.png');
    case 'my_comment_empty':
      return require('../img/abs_comment_icon_thumbsup_default_1.png');
    case 'my_drama_empty':
      return require('../img/abs_mybigplay_icon_bigplay_default.png');
    case 'my_draft_empty':
      return require('../img/abs_mydraft_icon_draft_default.png');
    case 'my_story_empty':
      return require('../img/abs_mylongtext_icon_longtext_default.png');
    case 'my_role_empty':
      return require('../img/abs_myrole_icon_role_default.png');
    case 'my_liked_empty':
      return require('../img/abs_liked_icon_thumbsup_default.png');
    case 'heart_gray':
      return require('../img/abs_generalize_btn_thumbsup_default.png');
    case 'my_comment_btn':
     return require('../img/abs_home_btn_comment_default.png');
    case 'my_forwarding_btn':
     return require('../img/abs_home_btn_forwarding_default.png');
    default:
      return;
  }
}

module.exports = {
  getImage
};
