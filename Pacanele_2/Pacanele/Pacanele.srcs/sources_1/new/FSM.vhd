----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/26/2022 09:22:15 PM
-- Design Name: 
-- Module Name: FSM - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FSM is 
Port 
(
signal clk:in std_logic; 
signal rst:in std_logic;
signal sw:in std_logic_vector(15 downto 0);
signal date:out std_logic_vector(31 downto 0);
signal btn_power_on_off:in std_logic;
signal btn_confirmare:in std_logic;
signal led:out std_logic_vector(15 downto 0)
 );
end FSM;

architecture Behavioral of FSM is

type stari is (idle,start,  pariu,scadere,animatie1,animatie2,animatie3,animatie4,evaluare,adunare,retragere);

signal stare_curenta:stari:=idle;
signal stare_urmatoare:stari:=idle;

signal sold:std_logic_vector(15 downto 0):=(others=>'0'); 
signal bet:std_logic_vector(15 downto 0):=(others=>'0'); 

signal counter:integer:=0;
signal clk_divizat:std_logic:='0';

signal counter1:std_logic_vector(3 downto 0):=(others=>'0');  
signal counter2:std_logic_vector(3 downto 0):=(others=>'0'); 
signal rez:std_logic_vector(3 downto 0):=(others=>'0');
signal rez1:std_logic_vector(3 downto 0):=(others=>'0');
signal rez2:std_logic_vector(3 downto 0):=(others=>'0');
signal rez3:std_logic_vector(3 downto 0):=(others=>'0');

signal stare:std_logic_vector(3 downto 0):=(others=>'0');
begin

process(clk,rst)
begin
if rst='1' then
    stare_curenta<=idle;
elsif clk='1' and clk'event then
    stare_curenta<=stare_urmatoare;
end if;
end process;

process(stare_curenta,btn_power_on_off,btn_confirmare,rez,rez1,rez2,rez3)
begin
case stare_curenta is
when idle=>if btn_power_on_off='1' then 
                stare_urmatoare<=start;
           else
                stare_urmatoare<=idle;
           end if;
when start=>if btn_confirmare='1' then
                stare_urmatoare<=pariu;
            else 
                stare_urmatoare<=start;
            end if; 
when pariu=>if btn_confirmare='1' then
                stare_urmatoare<=scadere;
            else 
                stare_urmatoare<=pariu;
            end if; 
when scadere=>stare_urmatoare<=animatie1;
when animatie1=>if btn_confirmare='1' then
                    stare_urmatoare<=animatie2;
                else 
                    stare_urmatoare<=animatie1;
                end if;
when animatie2=>if btn_confirmare='1' then
                    stare_urmatoare<=animatie3;
                else 
                    stare_urmatoare<=animatie2;
                end if; 
when animatie3=>if btn_confirmare='1' then
                    stare_urmatoare<=animatie4;
                else 
                    stare_urmatoare<=animatie3;
                end if;
when animatie4=>if btn_confirmare='1' then
                    stare_urmatoare<=evaluare;
                else 
                    stare_urmatoare<=animatie4;
                end if;    
when evaluare=> if (rez=rez1 and rez=rez2) and rez=rez3 then
                    stare_urmatoare<=adunare;
                else
                    stare_urmatoare<=retragere;
                end if; 
when adunare=>stare_urmatoare<=retragere;                                           
when others=>if btn_power_on_off='1' and btn_confirmare='0'  then 
                stare_urmatoare<=start;
             elsif btn_power_on_off='0' and btn_confirmare='1' then
                stare_urmatoare<=pariu;
             else
                stare_urmatoare<=retragere;
             end if;
             
end case;
end process;

process(clk,rst,clk_divizat)
begin
if rising_edge(clk) then
    if stare_curenta=idle then
        bet<=(others=>'0');
        sold<=(others=>'0');
        rez<=(others=>'0');
        rez1<=(others=>'0');
        rez2<=(others=>'0');
        rez3<=(others=>'0');
        
    end if;
    if stare_curenta=start then
        if btn_confirmare='1' then
            sold<=sw;
        end if;
    end if;
     
      
    
    if stare_curenta=pariu then
        if btn_confirmare='1' then
        bet<=sw;
        end if;
    end if;
     
    if stare_curenta=scadere then
        sold<=sold-bet;
    end if;
     
    if stare_curenta=animatie1 then
        rez<=counter1 xor counter2;
    end if;
    if stare_curenta=animatie2 then
        rez1<=counter1 xor counter2;
    end if;
    if stare_curenta=animatie3 then
        rez2<=counter1 xor counter2;
    end if;
    if stare_curenta=animatie4 then
        rez3<=counter1 xor counter2;
    end if;
    if stare_curenta=adunare then
        sold<=sold+bet+bet;
    end if;
end if;
if rst='1' then
    counter1<=(others=>'0');
    counter2<=(others=>'0');
elsif clk_divizat='1' and clk_divizat'event then
    counter1<=counter1+1;
    counter2<=counter2+2;
    
end if;
end process;

process(clk,rst)
begin
if rst='1' then
    counter<=0;
elsif clk'event and clk='1' then
    if counter<=4999999 then    
        counter<=counter+1;
    else
        counter<=0;
        clk_divizat<=not(clk_divizat);
    end if;
end if;
end process;

process(stare)
begin
case stare is 
when "0000"=>date<=(others=>'0');
when "0001"=>date<=(others=>'0');
when "0010"=>date<=x"0000" & sold;
when "0011"=>date<=sold & bet;
when "0100"=>date<=rez & rez1 & rez2 & rez3 & bet;
when "0101"=>date<=rez & rez1 & rez2 & rez3 & bet;
when "0110"=>date<=rez & rez1 & rez2 & rez3 & bet;
when "0111"=>date<=rez & rez1 & rez2 & rez3 & bet;
when "1000"=>date<=rez & rez1 & rez2 & rez3 & bet;
when "1001"=>date<=rez & rez1 & rez2 & rez3 & bet;
when others=>date<=sold & bet;
end case;
end process;

process(stare_curenta)
begin
case stare_curenta is
when idle=>stare<="0000";
when start=>stare<="0001";
when pariu=>stare<="0010";
when scadere=>stare<="0011";
when animatie1=>stare<="0100";
when animatie2=>stare<="0101";
when animatie3=>stare<="0110";
when animatie4=>stare<="0111";
when evaluare=>stare<="1000";
when adunare=>stare<="1001";
when others=>stare<="1010";
end case;
end process;
led<=x"000" & stare;
end Behavioral;
