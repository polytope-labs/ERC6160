pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../src/tokens/ERC20.sol";

contract ERC20Test is Test {
    MultiChainNativeERC20 token;
    address deployer = 0xb4c79daB8f259C7Aee6E5b2Aa729821864227e84;

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

    function testFailNotRoles() public view{
        assert(token.hasRole(MINTER_ROLE, address(0)));
        assert(token.hasRole(BURNER_ROLE, address(0)));
    }

    function testMintAndBurn() public {}
}