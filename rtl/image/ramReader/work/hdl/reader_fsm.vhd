-- VHDL Entity work.reader.symbol
--
-- Created:
--          by - kugel.kugel (pcakulap)
--          at - 15:59:59 09/26/13
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2012.2a (Build 3)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY reader IS
   PORT( 
      Empty  : IN     std_logic;
      active : IN     std_logic;
      clk    : IN     std_logic;
      newRow : IN     std_logic;
      rst    : IN     std_logic;
      cmdEn  : OUT    std_logic;
      readEn : OUT    std_logic
   );

-- Declarations

END reader ;

--
-- VHDL Architecture work.reader.fsm
--
-- Created:
--          by - kugel.kugel (pcakulap)
--          at - 15:59:59 09/26/13
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2012.2a (Build 3)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
 
ARCHITECTURE fsm OF reader IS

   -- Architecture Declarations
   SIGNAL cnt : integer RANGE 0 to 31;  

   TYPE STATE_TYPE IS (
      s1,
      s2,
      s3,
      s4,
      s0,
      s5,
      s6,
      s7
   );
 
   -- Declare current and next state signals
   SIGNAL current_state : STATE_TYPE;
   SIGNAL next_state : STATE_TYPE;

BEGIN

   -----------------------------------------------------------------
   clocked_proc : PROCESS ( 
      clk
   )
   -----------------------------------------------------------------
   BEGIN
      IF (clk'EVENT AND clk = '1') THEN
         IF (rst = '1') THEN
            current_state <= s0;
         ELSE
            current_state <= next_state;

            -- Combined Actions
            CASE current_state IS
               WHEN s2 => 
                  IF (active = '1') THEN 
                     cnt <= 0;
                  END IF;
               WHEN s3 => 
                  cnt <= cnt + 1;
               WHEN OTHERS =>
                  NULL;
            END CASE;
         END IF;
      END IF;
   END PROCESS clocked_proc;
 
   -----------------------------------------------------------------
   nextstate_proc : PROCESS ( 
      Empty,
      active,
      cnt,
      current_state,
      newRow
   )
   -----------------------------------------------------------------
   BEGIN
      CASE current_state IS
         WHEN s1 => 
            IF (newRow = '1') THEN 
               next_state <= s2;
            ELSE
               next_state <= s1;
            END IF;
         WHEN s2 => 
            IF (active = '1') THEN 
               next_state <= s3;
            ELSIF (active = '0') THEN 
               next_state <= s4;
            ELSE
               next_state <= s2;
            END IF;
         WHEN s3 => 
            IF (cnt = 30) THEN 
               next_state <= s2;
            ELSIF (active = '0') THEN 
               next_state <= s4;
            ELSE
               next_state <= s3;
            END IF;
         WHEN s4 => 
            IF (newRow = '1') THEN 
               next_state <= s7;
            ELSIF (empty = '1') THEN 
               next_state <= s1;
            ELSE
               next_state <= s4;
            END IF;
         WHEN s0 => 
            IF (true) THEN 
               next_state <= s5;
            ELSE
               next_state <= s0;
            END IF;
         WHEN s5 => 
            IF (empty = '1') THEN 
               next_state <= s6;
            ELSE
               next_state <= s5;
            END IF;
         WHEN s6 => 
            IF (active = '1') THEN 
               next_state <= s2;
            ELSE
               next_state <= s6;
            END IF;
         WHEN s7 => 
            IF (empty = '1') THEN 
               next_state <= s6;
            ELSE
               next_state <= s7;
            END IF;
         WHEN OTHERS =>
            next_state <= s0;
      END CASE;
   END PROCESS nextstate_proc;
 
   -----------------------------------------------------------------
   output_proc : PROCESS ( 
      Empty,
      active,
      current_state,
      newRow
   )
   -----------------------------------------------------------------
   BEGIN

      -- Combined Actions
      CASE current_state IS
         WHEN s1 => 
            readEn <= '0';
            cmdEn <= '0';
            IF (newRow = '1') THEN 
               cmdEn <= '1';
            END IF;
         WHEN s2 => 
            readEn <= '0';
            cmdEn <= '0';
            IF (active = '1') THEN 
               cmdEn <= '1';
               readEn <= '1';
            ELSIF (active = '0') THEN 
               readEn <= '1';
            END IF;
         WHEN s3 => 
            readEn <= '1';
            cmdEn <= '0';
         WHEN s4 => 
            readEn <= '1';
            cmdEn <= '0';
            IF (newRow = '1') THEN 
            ELSIF (empty = '1') THEN 
               readEn <= '0';
            END IF;
         WHEN s0 => 
            readEn <= '0';
            cmdEn <= '0';
         WHEN s5 => 
            readEn <= '1';
            cmdEn <= '0';
            IF (empty = '1') THEN 
               cmdEn <= '1';
            END IF;
         WHEN s6 => 
            readEn <= '0';
            cmdEn <= '0';
         WHEN s7 => 
            readEn <= '1';
            cmdEn <= '0';
            IF (empty = '1') THEN 
               cmdEn <= '1';
               readEn <= '0';
            END IF;
         WHEN OTHERS =>
            NULL;
      END CASE;
   END PROCESS output_proc;
 
END fsm;
