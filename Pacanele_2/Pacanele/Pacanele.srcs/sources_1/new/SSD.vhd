----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/17/2022 11:43:50 PM
-- Design Name: 
-- Module Name: ssd - Behavioral
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
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ssd is
Port 
( 
signal clk: in std_logic;
signal date: in std_logic_vector (31 downto 0);
signal an:out std_logic_vector(7 downto 0);
signal cat: out std_logic_vector(6 downto 0)
);
end ssd;

architecture Behavioral of ssd is
signal counter:std_logic_vector(16 downto 0);
signal hexa:std_logic_vector(3 downto 0);
begin
process(clk)
begin
if clk='1' and clk'event then
   counter<=counter+1;  
end if;
end process;
process(counter,date)
begin 
case counter(16 downto 14) is
when "000"=>an<="01111111";hexa<=date(31 downto 28);
when "001"=>an<="10111111";hexa<=date(27 downto 24);
when "010"=>an<="11011111";hexa<=date(23 downto 20);
when "011"=>an<="11101111";hexa<=date(19 downto 16);
when "100"=>an<="11110111";hexa<=date(15 downto 12);
when "101"=>an<="11111011";hexa<=date(11 downto 8);
when "110"=> an<="11111101";hexa<=date(7 downto 4);
when others=>an<="11111110";hexa<=date(3 downto 0);
end case;
end process;
process(hexa)
begin

case hexa is
when "0000" =>cat<="1000000";
when "0001" =>cat<="1111001";
when "0010" =>cat<="0100100";
when "0011" =>cat<="0110000";
when "0100" =>cat<="0011001";
when "0101" =>cat<="0010010";
when "0110" =>cat<="0000010";
when "0111" =>cat<="1111000";
when "1000" =>cat<="0000000";
when "1001" =>cat<="0010000";
when "1010" =>cat<="0001000";
when "1011" =>cat<="0000011";
when "1100" =>cat<="1000110";
when "1101" =>cat<="0100001";
when "1110" =>cat<="0000110";
when others =>cat<="0111111";
end case;
end process;
end Behavioral;
