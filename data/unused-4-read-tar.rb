#!/usr/bin/env ruby

#   struct tarfile_entry_posix
#   {                      //                               pack/unpack
#      char name[100];     // ASCII (+ Z unless filled)     a100/Z100
#      char mode[8];       // 0 padded, octal, null         a8  /A8
#      char uid[8];        // ditto                         a8  /A8
#      char gid[8];        // ditto                         a8  /A8
#      char size[12];      // 0 padded, octal, null         a12 /A12
#      char mtime[12];     // 0 padded, octal, null         a12 /A12
#      char checksum[8];   // 0 padded, octal, null, space  a8  /A8
#      char typeflag[1];   // see below                     a   /a
#      char linkname[100]; // ASCII + (Z unless filled)     a100/Z100
#      char magic[6];      // "ustar\0"                     a6  /A6
#      char version[2];    // "00"                          a2  /A2
#      char uname[32];     // ASCIIZ                        a32 /Z32
#      char gname[32];     // ASCIIZ                        a32 /Z32
#      char devmajor[8];   // 0 padded, octal, null         a8  /A8
#      char devminor[8];   // 0 padded, octal, null         a8  /A8
#      char prefix[155];   // ASCII (+ Z unless filled)     a155/Z155
#   };

HEADER_UNPACK_FORMAT  = "Z100x24A12"

File.open("data.tar","rb") do |f|
  while true
    data = f.read 136 # 100+8+8+8+12 - we don't want all the fields from header
    name,size = data.unpack(HEADER_UNPACK_FORMAT)

    # "end of archive is marked by at least 2 consecutive zero-filled records"
    # - but I make it simpler b/c I generate archive myself and guarantee that
    #   EOF is one empty entry // ZZZ
    break if name.empty?
    size = size.to_i(8)

    printf "[.] %04x: ", f.tell+376
    p [name,size]

    # The file data is written unaltered except that its length is rounded up
    # to a multiple of 512 bytes and the extra space is filled with zero bytes.
    if size & 0x1ff != 0
      size = (size | 0x1ff) + 1
    end


    # 376 = 512-136 - compensate for skipped header bytes
    f.seek size+376, IO::SEEK_CUR
  end
end
