-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 22.3.2024 10:02:38 UTC

library ieee;
use ieee.std_logic_1164.all;

entity tb_toplevel is
end tb_toplevel;

architecture tb of tb_toplevel is

    component toplevel
        port (VGA_R0    : out std_logic;
              VGA_R1    : out std_logic;
              VGA_R2    : out std_logic;
              VGA_R3    : out std_logic;
              VGA_G0    : out std_logic;
              VGA_G1    : out std_logic;
              VGA_G2    : out std_logic;
              VGA_G3    : out std_logic;
              VGA_B0    : out std_logic;
              VGA_B1    : out std_logic;
              VGA_B2    : out std_logic;
              VGA_B3    : out std_logic;
              VGA_HS    : out std_logic;
              VGA_VS    : out std_logic;
              CLK100MHZ : in std_logic);
    end component;

    signal VGA_R0    : std_logic;
    signal VGA_R1    : std_logic;
    signal VGA_R2    : std_logic;
    signal VGA_R3    : std_logic;
    signal VGA_G0    : std_logic;
    signal VGA_G1    : std_logic;
    signal VGA_G2    : std_logic;
    signal VGA_G3    : std_logic;
    signal VGA_B0    : std_logic;
    signal VGA_B1    : std_logic;
    signal VGA_B2    : std_logic;
    signal VGA_B3    : std_logic;
    signal VGA_HS    : std_logic;
    signal VGA_VS    : std_logic;
    signal CLK100MHZ : std_logic;

    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : toplevel
    port map (VGA_R0    => VGA_R0,
              VGA_R1    => VGA_R1,
              VGA_R2    => VGA_R2,
              VGA_R3    => VGA_R3,
              VGA_G0    => VGA_G0,
              VGA_G1    => VGA_G1,
              VGA_G2    => VGA_G2,
              VGA_G3    => VGA_G3,
              VGA_B0    => VGA_B0,
              VGA_B1    => VGA_B1,
              VGA_B2    => VGA_B2,
              VGA_B3    => VGA_B3,
              VGA_HS    => VGA_HS,
              VGA_VS    => VGA_VS,
              CLK100MHZ => CLK100MHZ);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that CLK100MHZ is really your main clock signal
    CLK100MHZ <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed

        -- EDIT Add stimuli here
        wait for 20ms;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_toplevel of tb_toplevel is
    for tb
    end for;
end cfg_tb_toplevel;