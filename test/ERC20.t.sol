pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../src/tokens/ERC20.sol";

contract ERC20Test is Test {
    MultiChainNativeERC20 token;
    address deployer = 0xb4c79daB8f259C7Aee6E5b2Aa729821864227e84;

    address beef = 0x000000000000000000000000000000000000bEEF;
    address dead = 0x000000000000000000000000000000000000dEaD;

    bytes4 constant _IERC6160Ext20_ID_ = 0xbbb8b47e;
    bytes4 constant _IERC_ACL_CORE_ID_ = 0x6bb9cd16;
    bytes4 constant _IERC5679Ext20_ID_ = 0xd0017968;

    // Roles
    bytes32 constant MINTER_ROLE = keccak256("MINTER ROLE");
    bytes32 constant BURNER_ROLE = keccak256("BURNER ROLE");

    function setUp() public {
        token = new MultiChainNativeERC20();
    }

    function testNameSymbol() public {
        assertEq(token.name(), "Multi Chain Native ERC20 TOken");
        assertEq(token.symbol(), "MCNT");
    }

    function testRoles() public view {
        assert(token.hasRole(MINTER_ROLE, address(this)));
        assert(token.hasRole(BURNER_ROLE, address(this)));
    }

    function testFailNotRoles() public view {
        assert(token.hasRole(MINTER_ROLE, address(0)));
        assert(token.hasRole(BURNER_ROLE, address(0)));
    }

    function testSupportInterface() public view {
        assert(token.supportsInterface(_IERC6160Ext20_ID_));
        assert(token.supportsInterface(_IERC5679Ext20_ID_));
        assert(token.supportsInterface(_IERC_ACL_CORE_ID_));
    }

    function testMintAndBurn() public {
        uint256 initialTotalSupply = token.totalSupply();

        token.mint(beef, 10, bytes(""));
        assertEq(token.balanceOf(beef), 10);
        assertEq(token.totalSupply(), initialTotalSupply + 10);


        token.burn(beef, 5, bytes(""));
        assertEq(token.balanceOf(beef), 5);
        assertEq(token.totalSupply(), initialTotalSupply + 5);
    }

    function testFailMintAndBurn() public {
        // from an unprivledged account should fail
        vm.prank(dead);
        token.mint(beef, 10, bytes(""));
    }
}