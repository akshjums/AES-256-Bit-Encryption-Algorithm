-- *************************************************************************
-- DISCLAIMER. THIS SOFTWARE WAS WRITTEN BY EMPLOYEES OF THE U.S.
-- GOVERNMENT AS A PART OF THEIR OFFICIAL DUTIES AND, THEREFORE, IS NOT
-- PROTECTED BY COPYRIGHT. HOWEVER, THIS SOFTWARE CODIFIES THE FINALIST
-- CANDIDATE ALGORITHMS (i.e., MARS, RC6tm, RIJNDAEL, SERPENT, AND
-- TWOFISH) IN THE ADVANCED ENCRYPTION STANDARD (AES) DEVELOPMENT EFFORT
-- SPONSORED BY THE NATIONAL INSTITUTE OF STANDARDS AND TECHNOLOGY (NIST)
-- AND MAY BE PROTECTED BY ONE OR MORE FORMS OF INTELLECTUAL PROPERTY. THE
-- U.S. GOVERNMENT MAKES NO WARRANTY, EITHER EXPRESSED OR IMPLIED,
-- INCLUDING BUT NO LIMITED TO ANY IMPLIED WARRANTIES OF MERCHANTABILITY
-- OR FITNESS FOR A PARTICULAR PURPOSE, REGARDING THIS SOFTWARE. THE U.S.
-- GOVERNMENT FURTHER MAKES NO WARRANTY THAT THIS SOFTWARE WILL NOT
-- INFRINGE ANY OTHER UNITED STATES OR FOREIGN PATENT OR OTHER
-- INTELLECTUAL PROPERTY RIGHT. IN NO EVENT SHALL THE U.S. GOVERNMENT BE
-- LIABLE TO ANYONE FOR COMPENSATORY, PUNITIVE, EXEMPLARY, SPECIAL,
-- COLLATERAL, INCIDENTAL, CONSEQUENTIAL, OR ANY OTHER TYPE OF DAMAGES IN
-- CONNECTION WITH OR ARISING OUT OF COPY OR USE OF THIS SOFTWARE.
-- *************************************************************************

-- ===========================================================================
-- File Name : controller_iter.vhdl
-- Author    : NSA
-- Date      : January 2000
-- Project   : RIJNDAEL iterative controller 
-- Purpose   : This block runs the timing and data ready signals
-- Notes     :   
-- ===========================================================================

library ieee;
use ieee.std_logic_1164.all;
use WORK.rijndael_pack.all;

-- ===========================================================================
-- =========================== Interface Description =========================
-- ===========================================================================

entity CONTROL_ITER is

  port (clock          :  in std_logic;
        reset          :  in std_logic;

        DATA_LOAD      :  in std_logic;   -- data start signal from interface
        CTRL_ENC       : in std_logic;   -- encrypt/decrypt signal

        CTRL_ALG_START :  out std_logic;  -- start encryption
        CTRL_KS_START  :  out std_logic   -- start key schedule
       
  );

end CONTROL_ITER;

architecture CONTROL_ITER_RTL of CONTROL_ITER is

signal DATA_LOAD_DEL : std_logic;

begin


-- ===========================================================================
-- =========================== Data Movement =================================
-- ===========================================================================

CTRL_KS_START <= DATA_LOAD when CTRL_ENC = '0' else
                 DATA_LOAD_DEL;

START_ALG: process ( clock, reset )

begin

   if reset = '1' then
    
      CTRL_ALG_START <= '0';

   elsif clock'event and clock = '1' then
 
      CTRL_ALG_START <= DATA_LOAD;
      DATA_LOAD_DEL  <= DATA_LOAD;

   end if; --if reset elsif clock'event
   
end process;

end CONTROL_ITER_RTL;
