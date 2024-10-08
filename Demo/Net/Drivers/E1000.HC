/*  Intel(R) E1000 Driver
    Author: TomAwezome

    Driver is based on:
    -   01000101's example i825xx driver
    -   OSDev Intel(R) 8254x documentation
    -   Intel(R) PCI/PCI-X Family of Gigabit Ethernet Controllers Software Developer's Manual
    -   Linux E1000 driver
    -   any other useful sources.

    Guidelines:
    -   Magic numbers are bad. #defines are good.
    -   Understandability over LOC.
    -   Clear documentation.
*/

// TODO: clean up entire driver

#define E1000_REG_CTRL  0x0000
#define E1000_REG_EERD  0x0014  // EEPROM Read
#define E1000_REG_ICR   0x00C0  // Interrupt Cause Read
#define E1000_REG_IMS   0x00D0
#define E1000_REG_RCTL  0x0100
#define E1000_REG_TCTL  0x0400
#define E1000_REG_RDBAL 0x2800
#define E1000_REG_RDBAH 0x2804
#define E1000_REG_RDLEN 0x2808
#define E1000_REG_RDH   0x2810
#define E1000_REG_RDT   0x2818
#define E1000_REG_TDBAL 0x3800
#define E1000_REG_TDBAH 0x3804
#define E1000_REG_TDLEN 0x3808
#define E1000_REG_TDH   0x3810
#define E1000_REG_TDT   0x3818
#define E1000_REG_MTA   0x5200  // Multicast Table Array

#define E1000_CTRLf_SLU 6 // Set Link Up ?

#define E1000_CTRLF_SLU (1 << E1000_CTRLf_SLU) // Set Link Up ?

#define E1000_RCTLf_EN              1
#define E1000_RCTLf_SBP             2
#define E1000_RCTLf_UPE             3
#define E1000_RCTLf_MPE             4
#define E1000_RCTLf_LPE             5
//#define E1000_RCTLf_RDMTS_HALF
#define E1000_RCTLf_RDMTS_QUARTER   8
#define E1000_RCTLf_RDMTS_EIGHTH    9
#define E1000_RCTLf_BAM             15
#define E1000_RCTLf_BSIZE_1024      16
#define E1000_RCTLf_BSIZE_512       17
#define E1000_RCTLf_BSIZE_256       18
//#define E1000_RCTLf_BSIZE_2048
//#define E1000_RCTLf_BSIZE_4096
//#define E1000_RCTLf_BSIZE_8192
//#define E1000_RCTLf_BSIZE_16384
#define E1000_RCTLf_SECRC           26

#define E1000_RCTLF_EN              (1 << E1000_RCTLf_EN)
#define E1000_RCTLF_SBP             (1 << E1000_RCTLf_SBP)
#define E1000_RCTLF_UPE             (1 << E1000_RCTLf_UPE)
#define E1000_RCTLF_MPE             (1 << E1000_RCTLf_MPE)
#define E1000_RCTLF_LPE             (1 << E1000_RCTLf_LPE)
//#define E1000_RCTLF_RDMTS_HALF
#define E1000_RCTLF_RDMTS_QUARTER   (1 << E1000_RCTLf_RDMTS_QUARTER)
#define E1000_RCTLF_RDMTS_EIGHTH    (2 << E1000_RCTLf_RDMTS_QUARTER)
#define E1000_RCTLF_BAM             (1 << E1000_RCTLf_BAM)
#define E1000_RCTLF_BSIZE_1024      (1 << E1000_RCTLf_BSIZE_1024)
#define E1000_RCTLF_BSIZE_512       (2 << E1000_RCTLf_BSIZE_1024)
#define E1000_RCTLF_BSIZE_256       (3 << E1000_RCTLf_BSIZE_1024)
//#define E1000_RCTLF_BSIZE_2048
//#define E1000_RCTLF_BSIZE_4096
//#define E1000_RCTLF_BSIZE_8192
//#define E1000_RCTLF_BSIZE_16384
#define E1000_RCTLF_SECRC           (1 << E1000_RCTLf_SECRC)

#define E1000_TCTLf_EN  1
#define E1000_TCTLf_PSP 3

#define E1000_TCTLF_EN  (1 << E1000_TCTLf_EN)
#define E1000_TCTLF_PSP (1 << E1000_TCTLf_PSP)

#define E1000_RDESC_STATUSf_EOP 1 // End of Packet: Last Descriptor for an incoming packet

#define E1000_RDESC_STATUSF_EOP (1 << E1000_RDESC_STATUSf_EOP)

#define E1000_EERDf_DONE    4

#define E1000_EERDF_DONE    (1 << E1000_EERDf_DONE)

#define E1000_TDESC_CMDf_EOP    0 // End of Packet: Last Descriptor making up the packet
#define E1000_TDESC_CMDf_IFCS   1 // Ins FCS/CRC field in Ethernet packets
#define E1000_TDESC_CMDf_RS     3 // Report Status: Ethernet controller needs to report status info

#define E1000_TDESC_CMDF_EOP    (1 << E1000_TDESC_CMDf_EOP)
#define E1000_TDESC_CMDF_IFCS   (1 << E1000_TDESC_CMDf_IFCS)
#define E1000_TDESC_CMDF_RS     (1 << E1000_TDESC_CMDf_RS)

#define E1000_TDESC_STATUSf_DD  0 // Descriptor Done: descriptor is finished and written-back
#define E1000_TDESC_STATUSf_EC  1 // Excess Collisions: packet hit too many collisions; not transmitted.
#define E1000_TDESC_STATUSf_LC  2 // Late Collision: late collision occurred (only for half-duplex mode)
#define E1000_TDESC_STATUSf_TU  3 // Transmit Underrun

#define E1000_TDESC_STATUSF_DD  (1 << E1000_TDESC_STATUSf_DD)
#define E1000_TDESC_STATUSF_EC  (1 << E1000_TDESC_STATUSf_EC)
#define E1000_TDESC_STATUSF_LC  (1 << E1000_TDESC_STATUSf_LC)
#define E1000_TDESC_STATUSF_TU  (1 << E1000_TDESC_STATUSf_TU)

#define E1000_ICRf_TXDW     0 // Transmit Descriptor Written Back
#define E1000_ICRf_TXQE     1 // Transmit Que Empty
#define E1000_ICRf_LSC      2 // Link Status Chg
#define E1000_ICRf_RXDMT    4 // Receive Descriptor Minimum Threshold Reached
#define E1000_ICRf_RXO      6 // Receive Data FIFO Overrun
#define E1000_ICRf_RXT      7 // Receive Timer Interrupt

#define E1000_ICRF_TXDW     (1 << E1000_ICRf_TXDW)
#define E1000_ICRF_TXQE     (1 << E1000_ICRf_TXQE)
#define E1000_ICRF_LSC      (1 << E1000_ICRf_LSC)
#define E1000_ICRF_RXDMT    (1 << E1000_ICRf_RXDMT)
#define E1000_ICRF_RXO      (1 << E1000_ICRf_RXO)
#define E1000_ICRF_RXT      (1 << E1000_ICRf_RXT)

#define E1000_IMSf_TXDW     0
#define E1000_IMSf_TXQE     1
#define E1000_IMSf_LSC      2
#define E1000_IMSf_RXSEQ    3
#define E1000_IMSf_RXDMT    4
#define E1000_IMSf_RXO      6
#define E1000_IMSf_RXT      7
#define E1000_IMSf_MDAC     9
#define E1000_IMSf_RXCFG    10
#define E1000_IMSf_PHYINT   12
#define E1000_IMSf_GPI      13 // 13-14
#define E1000_IMSf_TXDLOW   15
#define E1000_IMSf_SRPD     16

#define E1000_IMSF_TXDW     (1 << E1000_IMSf_TXDW)
#define E1000_IMSF_TXQE     (1 << E1000_IMSf_TXQE)
#define E1000_IMSF_LSC      (1 << E1000_IMSf_LSC)
#define E1000_IMSF_RXSEQ    (1 << E1000_IMSf_RXSEQ)
#define E1000_IMSF_RXDMT    (1 << E1000_IMSf_RXDMT)
#define E1000_IMSF_RXO      (1 << E1000_IMSf_RXO)
#define E1000_IMSF_RXT      (1 << E1000_IMSf_RXT)
#define E1000_IMSF_MDAC     (1 << E1000_IMSf_MDAC)
#define E1000_IMSF_RXCFG    (1 << E1000_IMSf_RXCFG)
#define E1000_IMSF_PHYINT   (1 << E1000_IMSf_PHYINT)
#define E1000_IMSF_GPI      (2 << E1000_IMSf_GPI) // flag sets both bits
#define E1000_IMSF_TXDLOW   (1 << E1000_IMSf_TXDLOW)
#define E1000_IMSF_SRPD     (1 << E1000_IMSf_SRPD)

#define E1000_RX_BUFF_COUNT 32  // 01000101's driver uses 768 for each of these...
#define E1000_TX_BUFF_COUNT 8

class CE1000DescriptorEntryRX
{
  U64   address;
  U16 length;
  U16 checksum;
  U8    status;
  U8    errors;
  U16   special;
};

class CE1000DescriptorEntryTX
{
  U64 address;
  U16 length;
  U8    cso;
  U8    cmd;
  U8    sta;
  U8    css;
  U16 special;
};

class CE1000
{
  CPCIDev *pci;

  U8    mac_address[6];
  U64   mmio_address;

  I64 current_rx_de_index;  // Current Receive DE being processed.  Gets incremented, wrapped to 0 at max of E1000_RX_BUFF_COUNT.
  I64 current_tx_de_index;  // Current Transmit DE being processed. Gets incremented, wrapped to 0 at max of E1000_TX_BUFF_COUNT.

  U8 *rx_de_buffer;         // Uncached-alias of pointer to the buffer of RX Descriptor Entries.
  U8 *tx_de_buffer;         // Uncached-alias of pointer to the buffer of TX Descriptor Entries.
  U8 *rx_de_buffer_phys;        // Pointer to the buffer of RX Descriptor Entries. (Code Heap, lower 2Gb)
  U8 *tx_de_buffer_phys;        // Pointer to the buffer of TX Descriptor Entries. (Code Heap, lower 2Gb)

  U64 rx_buffer_addr;           // Uncached-alias of address of receive buffers.
  U64 tx_buffer_addr;           // Uncached-alias of address of transmit buffers.
  U64 rx_buffer_addr_phys;  // Physical address of actual receive buffers  (< 4 Gb)
  U64 tx_buffer_addr_phys;  // Physical address of actual transmit buffers (< 4 Gb)


} e1000; // e1000 is the global variable we store all of this into.

CPCIDev *E1000PCIDevFind()
{// Find and return E1000 card as a CPCIDev pointer.
  CPCIDev *pci = PCIDevFind(PCIC_NETWORK,, PCIV_E1000);
  if (!pci)
    return NULL;
  ClassRep(pci);
  switch (pci->device_id)
  {
  case PCID_82545EM:
    break;
  default:
    pci = NULL;
  }
  return pci;
}

U32 E1000MMIORead(U32 offset)
{
  U32 *val = e1000.mmio_address + offset;
  return *val;
}

U0 E1000MMIOWrite(U32 offset, U32 val)
{
  U32 *addr = e1000.mmio_address + offset;
  *addr = val;
}

U16 E1000EEPROMRead(U8 word)
{// word arg is which U16 to read
  U16 data;
  U32 temp;
  E1000MMIOWrite(E1000_REG_EERD, 1 | word << 8);
  temp = E1000MMIORead(E1000_REG_EERD);
  while (!PCIBt(&temp, E1000_EERDf_DONE))
  {
    Sleep(1);
    temp = E1000MMIORead(E1000_REG_EERD);
  }
  data = temp.u16[1];
  return data;
}

U0 E1000MACGet()
{
  I64 i;
  U16 mac;
  NetLog("E1000 MAC GET: Getting MAC Address.");
  for (i = 0; i < 3; i++)
  {
    mac = E1000EEPROMRead(i);
    e1000.mac_address[2*i]   = mac.u8[0];
    e1000.mac_address[2*i+1] = mac.u8[1];
    NetLog(" %02X %02X", mac.u8[0], mac.u8[1]);
  }
}

I64 E1000PacketReceive(U8 **packet_buffer_out, U16 *packet_length_out)
{
  I64 de_index = e1000.current_rx_de_index;
  CE1000DescriptorEntryRX *entry = &e1000.rx_de_buffer[de_index * sizeof(CE1000DescriptorEntryRX)];
  Bool drop = FALSE;
  if (entry->length < 60)
  {
    NetErr("E1000 PACKET RECEIVE: Short Packet");
    drop = TRUE;
  }
  if (PCIBt(&entry->status, E1000_RDESC_STATUSf_EOP))
  {
    NetErr("E1000 PACKET RECEIVE: No EOP Set");
    drop = TRUE;
  }
  if (entry->errors)
  {
    NetErr("E1000 PACKET RECEIVE: RX DE Error Bits Set");
    drop = TRUE;
  }
  e1000.current_rx_de_index = (e1000.current_rx_de_index + 1) & (E1000_RX_BUFF_COUNT - 1);
  if (!drop)
  {
    *packet_buffer_out = entry->address;
    *packet_length_out = entry->length;
  }
  else
  {
    NetErr("E1000 PACKET RECEIVE: Dropping packet.");
    de_index = -1;
  }
  return de_index;
}

U0 E1000ReceivePacketRelease(I64 de_index)
{
  CE1000DescriptorEntryRX *entry = &e1000.rx_de_buffer[de_index * sizeof(CE1000DescriptorEntryRX)];
  entry->status = 0;
  E1000MMIOWrite(E1000_REG_RDT, e1000.current_rx_de_index);
}

Bool E1000DriverOwnsRX(CE1000DescriptorEntryRX *entry)
{
  return PCIBt(&entry->status, 0); // ?? TODO #define
}

I64 E1000TransmitPacketAllocate(U8 **packet_buffer_out, I64 length)
{
  I64 de_index = e1000.current_tx_de_index;
  CE1000DescriptorEntryTX *entry = &e1000.tx_de_buffer[de_index * sizeof(CE1000DescriptorEntryTX)];
  *packet_buffer_out = e1000.tx_buffer_addr + de_index * ETHERNET_FRAME_SIZE;
  MemSet(*packet_buffer_out, 0, ETHERNET_FRAME_SIZE); // Clear buffer contents in advance.
  entry->address    = *packet_buffer_out;
  entry->length = length;
  PCIBts(&entry->cmd, E1000_TDESC_CMDf_EOP);
  PCIBts(&entry->cmd, E1000_TDESC_CMDf_IFCS);
  PCIBts(&entry->cmd, E1000_TDESC_CMDf_RS);
  NetLog("E1000 ALLOCATE TX PACKET: de_index: %X.", de_index);
  return de_index;
}

U0 E1000TransmitPacketFinish(I64 de_index)
{
  CE1000DescriptorEntryTX *entry = &e1000.tx_de_buffer[de_index * sizeof(CE1000DescriptorEntryTX)];
  e1000.current_tx_de_index = (e1000.current_tx_de_index + 1) & (E1000_TX_BUFF_COUNT - 1);
  E1000MMIOWrite(E1000_REG_TDT, e1000.current_tx_de_index);
  ClassRep(entry);
  while (!(entry->sta & (E1000_TDESC_STATUSF_DD | E1000_TDESC_STATUSF_EC |
                         E1000_TDESC_STATUSF_LC | E1000_TDESC_STATUSF_TU)))
    Yield;
  NetLog("E1000 FINISH TX PACKET: TX DE index: %X.", de_index);
}

U0 EthernetFrameFinish(I64 de_index)
{//Alias for driver Finish TX function.
  E1000TransmitPacketFinish(de_index);
}

interrupt U0 E1000IRQ()
{// TODO need #defines
  U32                        icr = E1000MMIORead(E1000_REG_ICR);
  Bool                   poll = FALSE;
  CE1000DescriptorEntryRX *entry = e1000.rx_de_buffer;
  U8                        *packet_buffer;
  U16                        packet_length;
  I64                        de_index;
  icr &= ~(E1000_ICRF_TXDW | E1000_ICRF_TXQE);
  if (PCIBt(&icr, E1000_ICRf_LSC)) // 'link status change' ?
  {
    PCIBtr(&icr, E1000_ICRf_LSC);
    E1000MMIOWrite(E1000_REG_CTRL, E1000MMIORead(E1000_REG_CTRL) | E1000_CTRLF_SLU);
  }
  if (PCIBt(&icr, E1000_ICRf_RXO) || PCIBt(&icr, E1000_ICRf_RXDMT)) // 'rx underrun / min threshold' ?
  {
    PCIBtr(&icr, E1000_ICRf_RXO);
    PCIBtr(&icr, E1000_ICRf_RXDMT);
    poll = TRUE;
  }
  if (PCIBt(&icr, E1000_ICRf_RXT)) // 'packet pending' ?
  {
    PCIBtr(&icr, E1000_ICRf_RXT);
    poll = TRUE;
  }
  if (poll)
  {
    while (E1000DriverOwnsRX(&entry[e1000.current_rx_de_index]))
    {
      NetLog("$$BG,LTCYAN$$$$FG,WHITE$$"
             "==== E1000 IRQ ===="
             "$$BG$$$$FG$$");
      NetLog("$$BD,CYAN$$$$FD,WHITE$$"
             "E1000 IRQ: Saw owned RX DE index %d.", e1000.current_rx_de_index);
      de_index = E1000PacketReceive(&packet_buffer, &packet_length);
      if (de_index >= 0)
      {
        NetLog("E1000 IRQ: Pushing copy into Net Que, releasing receive packet.");
        NetQuePush(packet_buffer, packet_length);
        E1000ReceivePacketRelease(de_index);
      }
      NetLog("E1000 IRQ: Exiting.\n"
             "$$BD,WHITE$$$$FD,LTGRAY$$"
             "$$BG,LTCYAN$$$$FG,WHITE$$"
             "==================="
             "$$BG$$$$FG$$");
    }
  }
  E1000MMIORead(E1000_REG_ICR); // clear pending interrupts?
  *(dev.uncached_alias + LAPIC_EOI)(U32*) = 0;
}

U0 PCIInterruptsReroute(I64 base)
{// todo: comments explaining process, maybe better var names
  I64    i;
  U8    *da = dev.uncached_alias + IOAPIC_REG;
  U32 *_d = dev.uncached_alias + IOAPIC_DATA;
  for (i = 0; i < 4; i++)
  {
    *da = IOREDTAB + i * 2 + 1;
    *_d = dev.mp_apic_ids[INT_DEST_CPU] << 24;
    *da = IOREDTAB + i * 2;
    *_d = 0x4000 + base + i;
  }
}


U0 E1000InterruptsSetup()
{// .. ?
  I64 irq, i;
  for (i = 0; i < 4; i++)
    IntEntrySet((irq = IntEntryAlloc), &E1000IRQ);
  PCIInterruptsReroute(irq);
}

U0 E1000InitRX()
{
  I64 de_index;
  e1000.rx_de_buffer_phys = CAllocAligned(sizeof(CE1000DescriptorEntryRX) * E1000_RX_BUFF_COUNT,
                                          16,
                                          Fs->code_heap);
  e1000.rx_de_buffer = dev.uncached_alias + e1000.rx_de_buffer_phys;
  e1000.rx_buffer_addr_phys = CAlloc(ETHERNET_FRAME_SIZE * E1000_RX_BUFF_COUNT, Fs->code_heap);
  e1000.rx_buffer_addr = dev.uncached_alias + e1000.rx_buffer_addr_phys;
  // iterate de's and make packet buffers for each
  CE1000DescriptorEntryRX *entry = e1000.rx_de_buffer;
  for (de_index = 0; de_index < E1000_RX_BUFF_COUNT; de_index++)
  {
    entry->address = e1000.rx_buffer_addr + de_index * ETHERNET_FRAME_SIZE; // is this right? might need to change ?..
    // 01000101 MAlloc's 8208 for each DE
  }
  // setup rx de ring buffer
  E1000MMIOWrite(E1000_REG_RDBAH, e1000.rx_de_buffer >> 32);            // should we be using uncached addr here ?
  E1000MMIOWrite(E1000_REG_RDBAL, e1000.rx_de_buffer & 0xFFFFFFFF);
  // set receive buffer length
  E1000MMIOWrite(E1000_REG_RDLEN, E1000_RX_BUFF_COUNT * 16);
  // set head tail pointers
  E1000MMIOWrite(E1000_REG_RDH, 0);
  E1000MMIOWrite(E1000_REG_RDT, E1000_RX_BUFF_COUNT);
  // set receive control reg
  E1000MMIOWrite(E1000_REG_RCTL,    E1000_RCTLF_SBP         |
//                                  E1000_RCTLF_UPE         |
//                                  E1000_RCTLF_RDMTS_HALF  |
//                                  E1000_RCTLF_BSIZE_2048  |
//                                  E1000_RCTLF_MPE         |
                 E1000_RCTLF_SECRC      |
                 E1000_RCTLF_LPE            |
                 E1000_RCTLF_BAM);
}

U0 E1000InitTX()
{
  e1000.tx_de_buffer_phys = CAllocAligned(sizeof(CE1000DescriptorEntryTX) * E1000_TX_BUFF_COUNT,
                                          16,
                                          Fs->code_heap);
  e1000.tx_de_buffer = dev.uncached_alias + e1000.tx_de_buffer_phys;
  e1000.tx_buffer_addr_phys = CAlloc(ETHERNET_FRAME_SIZE * E1000_TX_BUFF_COUNT, Fs->code_heap);
  e1000.tx_buffer_addr = dev.uncached_alias + e1000.tx_buffer_addr_phys;
  // setup tx de ring buffer
  E1000MMIOWrite(E1000_REG_TDBAH, e1000.tx_de_buffer >> 32);            // should we be using uncached addr here ?
  E1000MMIOWrite(E1000_REG_TDBAL, e1000.tx_de_buffer & 0xFFFFFFFF);
  // set tx buffer length
  E1000MMIOWrite(E1000_REG_TDLEN, E1000_TX_BUFF_COUNT * 16);
  // set head tail pointers
  E1000MMIOWrite(E1000_REG_TDH, 0);
  E1000MMIOWrite(E1000_REG_TDT, E1000_RX_BUFF_COUNT);
  // set transmit control reg
  E1000MMIOWrite(E1000_REG_TCTL, E1000_TCTLF_EN | E1000_TCTLF_PSP);
}


U0 E1000Init()
{
  I64 i;
  MemSet(&e1000, 0, sizeof(CE1000)); // e1000 global var will hold member data the driver uses often.
  "\nE1000 driver WIP\n\n";
  e1000.pci = E1000PCIDevFind;
  if (!e1000.pci)
    return; // if we don't find the card, quit.
  e1000.mmio_address = dev.uncached_alias + e1000.pci->base[0] & ~0xF;
  // Assuming card supports MMIO... lower 4 bits are hardwired zero (?)
  "\nMMIO address: 0x%0X\n"
  , e1000.mmio_address;
  // init rx/tx addrs? (linux)
  // eeprom? MAC ?
  E1000MACGet;
  // setup link? (01000101's driver)
  E1000MMIOWrite(E1000_REG_CTRL, E1000MMIORead(E1000_REG_CTRL) | E1000_CTRLF_SLU);
  // zero out multicast hash? (linux)
  // zero out multicast table array (01000101's driver)
  for (i = 0; i < 128; i++)
    E1000MMIOWrite(E1000_REG_MTA + i*4, 0);
  // setup link? (linux)
  // clear all statistics regs after link establish attempt (linux)
  // enable & clear existing interupts (01000101's driver)
  E1000MMIOWrite(E1000_REG_IMS, E1000_IMSF_LSC      |
                 E1000_IMSF_RXSEQ   |
                 E1000_IMSF_RXDMT   |
                 E1000_IMSF_RXO     |
                 E1000_IMSF_RXT     |
                 E1000_IMSF_MDAC        |
                 E1000_IMSF_RXCFG   |
                 E1000_IMSF_PHYINT  |
                 E1000_IMSF_GPI     |
                 E1000_IMSF_TXDLOW  |
                 E1000_IMSF_SRPD);
  E1000MMIORead(E1000_REG_ICR); // clear pending interrupts ?
  // start rx tx?
  E1000InitRX;
  E1000InitTX;
  E1000InterruptsSetup;
  NetErr("TODO E1000");
  "\n";
  ClassRep(&e1000);
}

I64 EthernetFrameAllocate(U8 **packet_buffer_out,
                          U8 *source_address,
                          U8 *destination_address,
                          U16 ethertype,
                          I64 packet_length)
{
  U8 *ethernet_frame;
  I64 de_index;
  if (packet_length < ETHERNET_MIN_FRAME_SIZE)
  {
    NetWarn("ETHERNET FRAME ALLOCATE: Truncating length");
    packet_length = ETHERNET_MIN_FRAME_SIZE;
  }
  de_index = E1000TransmitPacketAllocate(&ethernet_frame, ETHERNET_MAC_HEADER_LENGTH + packet_length);
  if (de_index < 0)
  {
    NetErr("ETHERNET FRAME ALLOCATE: Failure");
    return -1; // Positive value expected. Functions calling this must factor this in.
  }
  MemCpy(ethernet_frame,                         destination_address, MAC_ADDRESS_LENGTH);
  MemCpy(ethernet_frame + MAC_ADDRESS_LENGTH, source_address,     MAC_ADDRESS_LENGTH);
  ethernet_frame[ETHERNET_ETHERTYPE_OFFSET]     = ethertype >> 8;
  ethernet_frame[ETHERNET_ETHERTYPE_OFFSET + 1] = ethertype & 0xFF;
  *packet_buffer_out = ethernet_frame + ETHERNET_MAC_HEADER_LENGTH;
  return de_index;
}

U8 *EthernetMACGet()
{
  return e1000.mac_address;
}

U0 NetStop()
{
}

U0 NetStart()
{
}

E1000Init;
