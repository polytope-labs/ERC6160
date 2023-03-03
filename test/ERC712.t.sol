pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../src/tokens/ERC721.sol";

contract ERC712Test is Test {
    MultiChainNativeERC721 token;
    address beef = 0x000000000000000000000000000000000000bEEF;
    address dead = 0x000000000000000000000000000000000000dEaD;

    // roles
    bytes32 constant MINTER_ROLE = keccak256("MINTER ROLE");
    bytes32 constant BURNER_ROLE = keccak256("BURNER ROLE");

    function setUp() public {
        token = new MultiChainNativeERC721();
    }

    function testRoles() public {
        assert(token.hasRole(MINTER_ROLE, address(this)));
        assert(token.hasRole(BURNER_ROLE, address(this)));
    }

    function testFailNotRoles() public {
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