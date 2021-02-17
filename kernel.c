void main() {
    char *video_memory = (char*) 0xb8000;
    *video_memory = 'W';
    char *video_memory1 = (char*) 0xb8002;
    *video_memory1 = 'e';
    char *video_memory2 = (char*) 0xb8004;
    *video_memory2 = 'e';
    char *video_memory3 = (char*) 0xb8006;
    *video_memory3 = 'O';
    char *video_memory4 = (char*) 0xb8008;
    *video_memory4 = 'S';
}
