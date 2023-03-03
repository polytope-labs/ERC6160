pragma solidity ^0.8.17;

import {IERC6160Ext20} from "./interfaces/IERC6160Ext20.sol";
import {IERC6160Ext721} from "./interfaces/IERC6160Ext721.sol";
import {IERC6160Ext1155} from "./interfaces/IERC6160Ext1155.sol";
contract Calculate {
    IERC6160Ext20 ierc6160ext20;
    IERC6160Ext721 ierc6160ext721;
    IERC6160Ext1155 ierc6160ext1155;

    // calculate selector for IERC6160Ext20
    function calculateSelectorIERC6160Ext20() external view returns(bytes4) {
        bytes4 selector =
            (ierc6160ext20.hasRole.selector ^ 
            ierc6160ext20.grantRole.selector ^
            ierc6160ext20.revokeRole.selector ^
            ierc6160ext20.mint.selector ^
            ierc6160ext20.burn.selector);
        return selector;
    }

    // calculate selector for IERC6160Ext721
    function calculateSelectorIERC6160Ext721() external view returns(bytes4) {
        bytes4 selector =
            (ierc6160ext721.hasRole.selector ^ 
            ierc6160ext721.grantRole.selector ^
            ierc6160ext721.revokeRole.selector ^
            ierc6160ext721.safeMint.selector ^
            ierc6160ext721.burn.selector);
        return selector;
    }

    // calculate selector for IERC6160Ext1155
    function calculateSelectorIERC6160Ext1155() external view returns(bytes4) {
        bytes4 selector =
            (ierc6160ext1155.hasRole.selector ^ 
            ierc6160ext1155.grantRole.selector ^
            ierc6160ext1155.revokeRole.selector ^
            ierc6160ext1155.safeMint.selector ^
            ierc6160ext1155.safeMintBatch.selector ^
            ierc6160ext1155.burn.selector ^
            ierc6160ext1155.burnBatch.selector);
        return selector;
    }
}