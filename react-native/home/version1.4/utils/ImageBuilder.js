/**
 * Created by flyye on 21/9/17.
 */

/**
 * @param imageUrl
 */
function getImage(imageUrl) {
    switch (imageUrl) {
        case 'search_btn':
            return require('../img/abs_icon_search_default.png');
        case 'delete_btn':
            return require('../img/abs_icon_delete_default.png');
        default:
            return;
    }
}

module.exports = {
    getImage
};
