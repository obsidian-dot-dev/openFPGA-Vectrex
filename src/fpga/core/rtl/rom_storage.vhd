library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity rom_storage is 
port(
  clk : in std_logic;
  wr_en : in std_logic;
  
  addr : in std_logic_vector( 16 downto 0);
  din : in std_logic_vector( 7 downto 0);   -- 8-bit input data (for ROM loading)
  
  dout : out std_logic_vector( 7 downto 0); -- 8-bit output data 

  -- sram bus parameters
  sram_a : out std_logic_vector( 16 downto 0);
  sram_dq : inout std_logic_vector( 15 downto 0); 
  sram_oe_n : out std_logic;
  sram_we_n : out std_logic;
  sram_ub_n : out std_logic; 
  sram_lb_n : out std_logic
);
end rom_storage;

architecture struct of rom_storage is
  signal sram_in : std_logic_vector( 7 downto 0);
  signal sram_out : std_logic_vector( 7 downto 0);
begin

sram_oe_n <= '0'; -- Output always enabled
sram_we_n <= '0' when wr_en = '1' else '1'; -- write enable only applies when chip select is held
sram_ub_n <= '0'; -- Only using the lower 8-bits of SRAM.
sram_lb_n <= '0'; -- Only using the lower 8-bits of SRAM.

sram_a <= addr; --  Address is lower-15 address bits plus 2 bank bits.
sram_dq <= ("00000000" & din) when wr_en = '1' else "ZZZZZZZZZZZZZZZZ";

dout <= sram_dq(7 downto 0);

end struct;
