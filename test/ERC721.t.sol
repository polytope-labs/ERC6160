pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../src/tokens/ERC6160Ext721.sol";

contract ERC721Test is Test {
    MultiChainNativeERC721 token;
    address beef = 0x000000000000000000000000000000000000bEEF;
    address dead = 0x000000000000000000000000000000000000dEaD;

    // supported interfaces
    bytes4 constant _IERC6160Ext721_ID_ = 0xa75a5a72;
    bytes4 constant _IERC_ACL_CORE_ID_ = 0x6bb9cd16;
    bytes4 constant _IERC5679Ext721_ID_ = 0xcce39764;

    // roles
    bytes32 constant MINTER_ROLE = keccak256("MINTER ROLE");
    bytes32 constant BURNER_ROLE = keccak256("BURNER ROLE");

    function setUp() public {
        token = new MultiChainNativeERC721(address(this), "", "");
    }

    function testRoles() public view {
        assert(token.hasRole(MINTER_ROLE, address(this)));
        assert(token.hasRole(BURNER_ROLE, address(this)));
    }

    function testFailNotRoles() public view {
        // test not granted roles
        assert(token.hasRole(MINTER_ROLE, beef));
        assert(token.hasRole(BURNER_ROLE, beef));
    }

    function testGrantedRoles() public {
        // test granted roles
        token.grantRole(MINTER_ROLE, beef);
        token.grantRole(BURNER_ROLE, beef);
        assert(token.hasRole(MINTER_ROLE, beef));
        assert(token.hasRole(BURNER_ROLE, beef));
    }

    function testSupportInterfaces() public view {
        assert(token.supportsInterface(_IERC6160Ext721_ID_));
        assert(token.supportsInterface(_IERC5679Ext721_ID_));
        assert(token.supportsInterface(_IERC_ACL_CORE_ID_));
    }

    function testMintAndBurn() public {
        token.safeMint(beef, 0, bytes(""));
        assert(token.exists(0));
        assertEq(token.ownerOf(0), beef);
    }

    function testFailMintAndBurn() public {
        // from an unprivledged account should fail
        vm.prank(dead);
        token.safeMint(beef, 1, bytes(""));
    }
}
