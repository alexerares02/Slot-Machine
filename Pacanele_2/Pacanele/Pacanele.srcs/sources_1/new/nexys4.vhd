----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/10/2022 06:32:28 PM
-- Design Name: 
-- Module Name: nexys4 - Behavioral
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
use IEEE.std_logic_unsigned .all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity nexys4 is
Port 
(
signal sw:in std_logic_vector (15 downto 0);
signal btn: in std_logic_vector (4 downto 0);
signal an: out std_logic_vector (7 downto 0);
signal cat : out std_logic_vector (6 downto 0);
signal led : out std_logic_vector (15 downto 0);
signal clk: in std_logic
 );
end nexys4;

architecture Behavioral of nexys4 is
signal btn_on_off:std_logic;
signal btn_start_confirmare:std_logic;
signal btn_rst:std_logic;


signal date:std_logic_vector(31 downto 0);
signal afisare_ssd_balanta:std_logic_vector(15 downto 0);
signal afisare_ssd_miza:std_logic_vector(3 downto 0);
signal afisare_ssd_animatie:std_logic_vector(11 downto 0);

begin



btnu:entity WORK.mpg port map
(
btn=>btn(1),
clk=>clk,
en=>btn_rst
);

btnc:entity WORK.mpg port map
(
btn=>btn(0),
clk=>clk,
en=>btn_on_off
);

btnd:entity WORK.mpg port map
(
btn=>btn(2),
clk=>clk,
en=>btn_start_confirmare
);

afisor:entity WORK.ssd port map
(
clk=>clk,
date=>date,
an=>an,
cat=>cat
);

-- ma doare mintea sa verific asta 
--UCC:Unitate_control port map
--(
--clk=>clk,
--btn_on_off=>btn_on_off,
--btn_rst=>btn_rst,
--btn_start_confirmare=>btn_start_confirmare,
--sw=>sw,
--afisare_ssd_balanta=>afisare_ssd_balanta,
--afisare_ssd_miza=>afisare_ssd_miza,
--afisare_ssd_animatie=>afisare_ssd_animatie
--);

FSM:entity WORK.FSM port map
(
 clk=>clk,
 rst=>btn_rst, 
 sw=>sw,
 date=>date,
 btn_power_on_off=>btn_on_off,
 btn_confirmare=>btn_start_confirmare,
 led=>led
);
date<=date;

end Behavioral;
