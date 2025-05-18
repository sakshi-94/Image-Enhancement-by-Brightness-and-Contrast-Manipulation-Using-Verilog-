/****************** Module for writing .bmp image *************/ 
module image_write #(parameter 
    WIDTH = 640, // Image width 
    HEIGHT = 426, // Image height 
    INFILE = "output.bmp", // Output image 
    BMP_HEADER_NUM = 54 // Header for bmp image 
) 
( 
    input HCLK, // Clock input 
    input HRESETn, // Reset active low 
    input hsync, // Hsync pulse 
    input [7:0] DATA_WRITE_R0, // Red 8-bit data (odd) 
    input [7:0] DATA_WRITE_G0, // Green 8-bit data (odd) 
    input [7:0] DATA_WRITE_B0, // Blue 8-bit data (odd) 
    input [7:0] DATA_WRITE_R1, // Red 8-bit data (even) 
    input [7:0] DATA_WRITE_G1, // Green 8-bit data (even) 
    input [7:0] DATA_WRITE_B1, // Blue 8-bit data (even) 
    output reg Write_Done 
); 

// Declare variables that were missing
reg [7:0] BMP_header [0:BMP_HEADER_NUM-1]; // Array to store BMP header
integer fd; // File descriptor
integer i; // Loop counter
reg [7:0] out_BMP [0:WIDTH*HEIGHT*3-1]; // Array to store output BMP data

//-------Header data for bmp image-----// 
// Windows BMP files begin with a 54-byte header
initial begin 
    BMP_header[ 0] = 66;BMP_header[28] = 24; 
    BMP_header[ 1] = 77;BMP_header[29] = 0; 
    BMP_header[ 2] = 22;BMP_header[30] = 0; 
    BMP_header[ 3] = 123;BMP_header[31] = 0;
    BMP_header[ 4] = 12;BMP_header[32] = 0;
    BMP_header[ 5] = 0;BMP_header[33] = 0; 
    BMP_header[ 6] = 0;BMP_header[34] = 0; 
    BMP_header[ 7] = 0;BMP_header[35] = 0; 
    BMP_header[ 8] = 0;BMP_header[36] = 0; 
    BMP_header[ 9] = 0;BMP_header[37] = 0; 
    BMP_header[10] = 54;BMP_header[38] = 0; 
    BMP_header[11] = 0;BMP_header[39] = 0; 
    BMP_header[12] = 0;BMP_header[40] = 0; 
    BMP_header[13] = 0;BMP_header[41] = 0; 
    BMP_header[14] = 40;BMP_header[42] = 0; 
    BMP_header[15] = 0;BMP_header[43] = 0; 
    BMP_header[16] = 0;BMP_header[44] = 0; 
    BMP_header[17] = 0;BMP_header[45] = 0; 
    BMP_header[18] = 128;BMP_header[46] = 0; 
    BMP_header[19] = 2;BMP_header[47] = 0;
    BMP_header[20] = 0;BMP_header[48] = 0;
    BMP_header[21] = 0;BMP_header[49] = 0; 
    BMP_header[22] = 170;BMP_header[50] = 0; 
    BMP_header[23] = 1;BMP_header[51] = 0; 
    BMP_header[24] = 0;BMP_header[52] = 0; 
    BMP_header[25] = 0;BMP_header[53] = 0; 
    BMP_header[26] = 1; 
    BMP_header[27] = 0; 
end

//---------------------------------------------------------//
//--------------Write .bmp file  ----------------------//
//----------------------------------------------------------//
initial begin
    fd = $fopen(INFILE, "wb+");
end

// Added logic to capture image data
reg [10:0] row, col;
reg [18:0] data_count;
reg processing_done;

// Process to count rows and columns
always @(posedge HCLK or negedge HRESETn) begin
    if(!HRESETn) begin
        row <= 0;
        col <= 0;
        data_count <= 0;
        processing_done <= 0;
    end
    else if(hsync) begin
        if(col == WIDTH-2) begin
            col <= 0;
            row <= row + 1;
        end
        else begin
            col <= col + 2; // Process 2 pixels at a time
        end
        
        // Store pixel data in out_BMP array
        out_BMP[WIDTH*3*(HEIGHT-1-row)+3*col]   = DATA_WRITE_B0;
        out_BMP[WIDTH*3*(HEIGHT-1-row)+3*col+1] = DATA_WRITE_G0;
        out_BMP[WIDTH*3*(HEIGHT-1-row)+3*col+2] = DATA_WRITE_R0;
        out_BMP[WIDTH*3*(HEIGHT-1-row)+3*col+3] = DATA_WRITE_B1;
        out_BMP[WIDTH*3*(HEIGHT-1-row)+3*col+4] = DATA_WRITE_G1;
        out_BMP[WIDTH*3*(HEIGHT-1-row)+3*col+5] = DATA_WRITE_R1;
        
        data_count <= data_count + 1;
        
        // Check if all data has been processed
        if(data_count == WIDTH*HEIGHT/2 - 1) begin
            processing_done <= 1;
        end
    end
end

// Set Write_Done flag when processing is complete
always @(posedge HCLK or negedge HRESETn) begin
    if(!HRESETn) begin
        Write_Done <= 0;
    end
    else if(processing_done) begin
        Write_Done <= 1;
    end
end

always@(Write_Done) begin // once the processing was done, bmp image will be created
    if(Write_Done == 1'b1) begin
        for(i=0; i<BMP_HEADER_NUM; i=i+1) begin
            $fwrite(fd, "%c", BMP_header[i][7:0]); // write the header
        end
        
        for(i=0; i<WIDTH*HEIGHT*3; i=i+6) begin
            // write R0B0G0 and R1B1G1 (6 bytes) in a loop
            $fwrite(fd, "%c", out_BMP[i  ][7:0]);
            $fwrite(fd, "%c", out_BMP[i+1][7:0]);
            $fwrite(fd, "%c", out_BMP[i+2][7:0]);
            $fwrite(fd, "%c", out_BMP[i+3][7:0]);
            $fwrite(fd, "%c", out_BMP[i+4][7:0]);
            $fwrite(fd, "%c", out_BMP[i+5][7:0]);
        end
        
        $fclose(fd);
    end
end

endmodule
