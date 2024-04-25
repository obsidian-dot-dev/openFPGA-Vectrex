library ieee;
use ieee.std_logic_1164.all,ieee.numeric_std.all;

entity expander_lut is
port (
	data     : in  std_logic_vector(5 downto 0);
	data_exp : out std_logic_vector(7 downto 0)
);
end entity;

architecture prom of expander_lut is
	type rom is array(0 to  63) of std_logic_vector(7 downto 0);
	signal rom_data: rom := (
  X"00",X"0B",X"13",X"1A",X"20",X"26",X"2C",X"31",X"36",X"3B",X"40",X"45",X"4A",X"4E",X"53",
  X"57",X"5B",X"5F",X"64",X"68",X"6C",X"70",X"74",X"78",X"7C",X"7F",X"83",X"87",X"8B",X"8F",
  X"92",X"96",X"99",X"9D",X"A1",X"A4",X"A8",X"AB",X"AF",X"B2",X"B5",X"B9",X"BC",X"BF",X"C3",
  X"C6",X"C9",X"CD",X"D0",X"D3",X"D6",X"DA",X"DD",X"E0",X"E3",X"E6",X"E9",X"ED",X"F0",X"F3",
  X"F6",X"F9",X"FC",X"FF"
  );
begin
data_exp <= rom_data(to_integer(unsigned(data)));
end architecture;

