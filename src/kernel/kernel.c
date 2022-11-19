void main() {
	char *video_memory = (char *) 0xb8000;

	for (int i = 0; i < 160*25; i++) {
		*(video_memory+i) = ' ';
	}

	*video_memory = 'X';
}
