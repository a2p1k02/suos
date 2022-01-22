#ifndef FRAMEBUFFER_H
#define FRAMEBUFFER_H

void fb_move_cursor(unsigned short pos);
void fb_write_cell(unsigned int i, char c, unsigned char fg, unsigned char bg);

#endif //FRAMEBUFFER_H

