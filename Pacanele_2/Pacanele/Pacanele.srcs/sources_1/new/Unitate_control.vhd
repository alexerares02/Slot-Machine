----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/10/2022 07:36:52 PM
-- Design Name: 
-- Module Name: Unitate_control - Behavioral
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
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Unitate_control is
Port (
signal clk:in std_logic;
signal btn_on_off:in std_logic;
signal btn_rst:in std_logic;
signal btn_start_confirmare:in std_logic;
signal sw:in std_logic_vector(15 downto 0);
signal afisare_ssd_balanta:out std_logic_vector(15 downto 0);
signal afisare_ssd_miza:out std_logic_vector(3 downto 0);
signal afisare_ssd_animatie:out std_logic_vector(11 downto 0)
 );
end Unitate_control;

architecture Behavioral of Unitate_control is

-- semnale pentru fsm
type stari is (idle,introducere_valuta,afisare_valuta,introducere_miza,afisare_miza,animatie,afisare_animatie,rezultat,afisare_rezultat,stop);
signal stare_curenta:stari:=idle;
signal stare_urmatoare:stari:=idle;

--semnale interne
signal sold_curent:std_logic_vector(15 downto 0):=(others=>'0');
signal miza:std_logic_vector(3 downto 0):=(others=>'0');
signal sloturi:std_logic_vector(11 downto 0);

--semnale pt slot
signal slot1:std_logic_vector(3 downto 0):=(others=>'0');
signal slot2:std_logic_vector(3 downto 0):=(others=>'0');
signal slot3:std_logic_vector(3 downto 0):=(others=>'0');

--semnale numaratoare pt sloturi
signal num1:std_logic_vector(3 downto 0):="0000";
signal num2:std_logic_vector(3 downto 0):="1111";
signal num3:std_logic_vector(3 downto 0):="0000";
signal num4:std_logic_vector(3 downto 0):="0001";
signal num5:std_logic_vector(3 downto 0):="0001";
signal num6:std_logic_vector(3 downto 0):="1111";

--semnal pentru animatie sa treaca mai departe
signal dep:std_logic:='0';



begin

--proces de actualizare a starii actuale
process(clk,btn_rst)
begin 
if btn_rst='1' then
stare_curenta<=idle;
elsif clk='1' and clk'event then
stare_curenta<=stare_urmatoare;
end if;
end process;

--proces pentru a determina starea urmatoare
process(stare_curenta,btn_on_off,btn_start_confirmare)
begin
case stare_curenta is

when idle=>if btn_on_off='1' then
                stare_urmatoare<=introducere_valuta;
           else stare_urmatoare<=idle;
           end if;
           
when introducere_valuta=>if btn_start_confirmare='1' then
                            stare_urmatoare<=afisare_valuta;
                         else
                            stare_urmatoare<=introducere_valuta;
                         end if;
when afisare_valuta=> if btn_start_confirmare='1'  then
                      if sold_curent/=x"0000" then
                      stare_urmatoare<=introducere_miza;
                      else stare_urmatoare<=introducere_valuta;
                      end if;
                      else stare_urmatoare<=afisare_valuta;
                      end if;
                         
when introducere_miza=>if btn_start_confirmare='1'  then
                            stare_urmatoare<=afisare_miza;
                       end if;
                       
when afisare_miza=> if btn_start_confirmare='1' then
                    if miza/="0000" and miza<sold_curent then
                    stare_urmatoare<=animatie;
                    else stare_urmatoare<=introducere_miza;    
                    end if;
                    else stare_urmatoare<=afisare_miza;
                    end if;

when animatie=> if dep='1' then 
                stare_urmatoare<=afisare_animatie;
                else stare_urmatoare<=animatie;
                end if;
                
when afisare_animatie=>stare_urmatoare<=rezultat;
when rezultat=>stare_urmatoare<=afisare_rezultat;
when afisare_rezultat=>if btn_on_off='1' then
                        stare_urmatoare<=idle;
                        elsif btn_start_confirmare='1' then
                        stare_urmatoare<=introducere_miza;
                        end if;

when others=>stare_urmatoare<=stop;--hazardul
end case;           
end process;

--proces pentru a determina afisare
process(stare_curenta)
begin
case stare_curenta is
when idle=>afisare_ssd_balanta<=(others=>'0');
           afisare_ssd_miza<=(others=>'0');
           afisare_ssd_animatie<=(others=>'0');
when introducere_valuta=>afisare_ssd_balanta<=sold_curent;
when introducere_miza=>afisare_ssd_miza<=miza;
when animatie=>afisare_ssd_animatie(11 downto 8)<=sloturi(11 downto 8);
                afisare_ssd_animatie(7 downto 4)<=sloturi(7 downto 4) ;
                afisare_ssd_animatie(3 downto 0)<=sloturi(3 downto 0) ;
                afisare_ssd_balanta<=sold_curent;
when rezultat=>afisare_ssd_balanta<=sold_curent;


when others=>afisare_ssd_balanta<=(others=>'0');
           afisare_ssd_miza<=(others=>'0');
           afisare_ssd_animatie<=(others=>'0');
end case;
end process;
--proces in fucntie de clk pt semnale interne
process(clk)
begin

if clk='1' and clk'event then
if stare_curenta=idle then 
sold_curent<=(others=>'0');
miza<=(others=>'0');
end if;
if stare_curenta=introducere_valuta then 
if btn_start_confirmare='1' then
sold_curent<=sw;
end if;
end if;
if stare_curenta=introducere_miza then
if btn_start_confirmare='1' then
miza<=sw(3 downto 0);
end if;
end if;
if stare_curenta=animatie then
sloturi<=slot1 & slot2 & slot3; 
dep<='1' ;
sold_curent<=sold_curent-miza;
end if;
if stare_curenta=rezultat then
if sloturi(11 downto 8)=sloturi(7 downto 4) and sloturi(7 downto 4) = sloturi(3 downto 0) then
if sloturi(11 downto 8)>"1001" and sloturi(11 downto 8)<"1110" then

sold_curent<=(sold_curent+miza)+miza;

end if;
if sloturi(11 downto 8)>"1101" then
sold_curent<=((sold_curent+miza)+miza)+miza;
end if;
end if;
end if;
end if;
end process;

--proces pentru numaratoarele pt sloturi
process(clk,btn_rst)
begin
if btn_rst='1' then
num1<="0000";
num2<="1111";
num3<="0000";
num4<="0001";
num5<="0001";
num6<="1111";

elsif clk='1' and clk'event then
num1<=num1+1;
num2<=num2-1;
num3<=num3+2;
num4<=num4+1;
num5<=num5+1;
num6<=num6-2;

end if;
end process;

slot1<=(num1 xor num2) xor num3;
slot2<=(num4 xor num5) xor num6;
slot3<=(num1 xor num3) xor num4;

end Behavioral;


