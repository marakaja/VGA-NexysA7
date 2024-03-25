library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity toplevel is
    port (
    -- Port definition for VGA Connector
    -- VGA_R[0]
    VGA_R0: out std_logic;
    -- VGA_R[1]
    VGA_R1: out std_logic;
    -- VGA_R[2]
    VGA_R2: out std_logic;
    -- VGA_R[3]
    VGA_R3: out std_logic;
    -- VGA_G[0]
    VGA_G0: out std_logic;
    -- VGA_G[1]
    VGA_G1: out std_logic;
    -- VGA_G[2]
    VGA_G2: out std_logic;
    -- VGA_G[3]
    VGA_G3: out std_logic;
    -- VGA_B[0]
    VGA_B0: out std_logic;
    -- VGA_B[1]
    VGA_B1: out std_logic;
    -- VGA_B[2]
    VGA_B2: out std_logic;
    -- VGA_B[3]
    VGA_B3: out std_logic;
    
    -- VGA_HS
    VGA_HS: out std_logic;
    -- VGA_VS
    VGA_VS: out std_logic;

    CLK100MHZ : in std_logic
    );

end toplevel;

architecture Behavioral of toplevel is

component pixelgen is
    port (
            clk : in    std_logic  ;
            pixel_data : out std_logic_vector(11 downto 0);
            row : in std_logic_vector(9 downto 0);
            col : in std_logic_vector(9 downto 0)
            );
end component pixelgen;

component simple_counter is
    generic (
        NBIT : integer := 3; --! Default number of counter bits
        PERIOD : integer range 1 to integer'high := 5; --! counter length
        SYNC_LOW : integer range 1 to integer'high; --! Counter value for sync low
        SYNC_HIGH : integer range 1 to integer'high --! Counter value for sync high
    );
    port (
        clk   : in    std_logic;                          --! Main clock
        rst   : in    std_logic;                          --! High-active synchronous reset
        en    : in    std_logic;                          --! Clock enable input
        count : out   std_logic_vector(NBIT - 1 downto 0); --! Counter value
        sync  : out   std_logic;
        counter_end : out std_logic     --! End of line
    );
end component simple_counter;


signal color : std_logic_vector(11 downto 0);
signal row : std_logic_vector(9 downto 0);
signal col : std_logic_vector(9 downto 0);
signal pixel_freq : std_logic;
signal endline : std_logic;



begin

VGA_R0 <= color(11);
VGA_R1 <= color(10);
VGA_R2 <= color(9);
VGA_R3 <= color(8);
VGA_G0 <= color(7);
VGA_G1 <= color(6);
VGA_G2 <= color(5);
VGA_G3 <= color(4);
VGA_B0 <= color(3);
VGA_B1 <= color(2);
VGA_B2 <= color(1);
VGA_B3 <= color(0);

pxlgen : pixelgen 
    port map(
        clk => CLK100MHZ,
        pixel_data => color,
        row => row,
        col => col
        );

CLOCK_DIV : simple_counter
    generic map (
        NBIT => 3,
        PERIOD => 5,
        SYNC_LOW => 1,
        SYNC_HIGH => 2
    )
    port map (
        clk => CLK100MHZ,
        rst => '0',
        en => '1',
        count => open,
        sync => open,
        counter_end => pixel_freq
    );

HSYNC : simple_counter
    generic map (
        NBIT => 10,
        PERIOD => 528,
        SYNC_LOW => 420,
        SYNC_HIGH => 484
    )
    port map (
        clk => pixel_freq,
        rst => '0',
        en => '1',
        count => col,
        sync => VGA_HS,
        counter_end => endline
    );

VSYNC : simple_counter
    generic map (
        NBIT => 10,
        PERIOD => 628,
        SYNC_LOW => 601,
        SYNC_HIGH => 605
    )
    port map (
        clk => endline,
        rst => '0',
        en => '1',
        count => row,
        sync => VGA_VS,
        counter_end => open
    );

end Behavioral;
