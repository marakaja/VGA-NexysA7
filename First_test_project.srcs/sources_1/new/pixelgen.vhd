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
        col : in std_logic_vector(9 downto 0);

        rx_data : in std_logic_vector(7 downto 0);
        rx_data_valid : in std_logic;
        rx_data_last : in std_logic
        );
end pixelgen;

architecture Behavioral of pixelgen is

signal pixel_address : std_logic_vector(16 downto 0);
signal in_pixel_range : std_logic;
signal addr : std_logic_vector(19 downto 0);
signal pixel_out :  std_logic_vector(11 downto 0);

signal writeAddr : std_logic_vector(16 downto 0) := (others => '0');
signal writeData : std_logic_vector(11 downto 0) := (others => '0');
signal writeEnable : std_logic_vector(0 downto 0) := (others => '0');

signal lastRxDataValid : std_logic := '0';

signal byteCounter : integer := 0;
signal bytesInPacket : integer := 0;

component blk_mem_gen_0 IS
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(16 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    clkb : IN STD_LOGIC;
    enb : IN STD_LOGIC;
    addrb : IN STD_LOGIC_VECTOR(16 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(11 DOWNTO 0) 
  );
end component blk_mem_gen_0;

begin

mem : component blk_mem_gen_0
    port map(
    clka => clk,
    clkb => clk,

    addrb => pixel_address,
    doutb => pixel_out,

    wea => writeEnable,
    dina => writeData,
    addra => writeAddr,
    enb => '1'
    );

  addr  <=  std_logic_vector(400 * (unsigned(row)/2) + unsigned(col)) when (in_pixel_range = '1') else (others => '0');
  pixel_data  <= pixel_out when (in_pixel_range = '1') else (others => '0');
  
  pixel_address <= addr(16 downto 0);

  in_pixel_range <= '1' when (unsigned (row) < 600 and unsigned (col) < 400) else '0';
  
  process(clk)
  begin
    if rising_edge(clk) then
      if rx_data_valid = '1' then

        if bytesInPacket < 5 then --TODO define header of packet size
          case bytesInPacket is
            when 0 => 
              --Set incoming data as the least significant byte of the address
              writeAddr <= writeAddr(16 downto 8) & rx_data ;
            when 1 =>
              --Set incoming data as the more significant byte of the address
              writeAddr <= writeAddr(16 downto 16) & rx_data & writeAddr(7 downto 0);
            when 2 =>
              writeAddr <= rx_data(0 downto  0) & writeAddr(15 downto 0);


            when others =>
              null;
          end case;
          
          
        else
         
        
          if byteCounter = 1 then
            writeData <= writeData(11 downto 8) & rx_data;
            byteCounter <=  0;
            writeEnable <= "1";
          else
            writeEnable <= "0";
            writeData <= (rx_data(3 downto 0) & x"00");
            byteCounter <= byteCounter + 1;
            writeAddr <= std_logic_vector(UNSIGNED(writeAddr) + 1);
          end if;
          
        end if;

        lastRxDataValid <= rx_data_valid;     
        bytesInPacket <= bytesInPacket + 1;
     
      else
        writeEnable <= "0";
        byteCounter <= 0;
        bytesInPacket <= 0;
      end if;


    end if;
  end process;



end Behavioral;
