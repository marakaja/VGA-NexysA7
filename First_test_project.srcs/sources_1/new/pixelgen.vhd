----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.03.2024 19:06:36
-- Design Name: 
-- Module Name: pixelgen - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
use ieee.numeric_std.all; -- Package for data type conversions


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pixelgen is
 port (
        clk : in    std_logic  ;
        pixel_data : out std_logic_vector(11 downto 0);
        row : in std_logic_vector(9 downto 0);
        col : in std_logic_vector(9 downto 0)
        );
end pixelgen;

architecture Behavioral of pixelgen is

signal pixel_address : std_logic_vector(16 downto 0);
signal in_pixel_range : std_logic;
signal addr : std_logic_vector(19 downto 0);

component blk_mem_gen_0 IS
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(16 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
  );
end component blk_mem_gen_0;

begin

mem : component blk_mem_gen_0
    port map(
    clka => clk,
    wea => "0",
    addra => pixel_address,
    dina => "000000000000",
    douta => pixel_data
    );

  addr  <=  std_logic_vector(400 * (unsigned(row)/2) + unsigned(col)) when (in_pixel_range = '1') else (others => '0');
  pixel_address <= addr(16 downto 0);

  in_pixel_range <= '1' when (unsigned (row) < 300 and unsigned (col) < 400) else '0';



end Behavioral;
