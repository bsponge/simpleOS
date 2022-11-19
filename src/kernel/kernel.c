void main() {
	char *video_memory = (char *) 0xb8000;

	for (int i = 0; i < 160*2; i++) {
		*(video_memory+i) = ' ';
	}

	char *msg = "Hello World!";
	for (int i = 0; msg[i/2] ; i+=2) {
		*(video_memory+i) = msg[i/2];
	}
}
