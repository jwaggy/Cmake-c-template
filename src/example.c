#include <stdio.h>

#include <version.h>


__attribute__ ((unused)) // This line lets you use this variable in your program somewhere or just leave it as is compiled in.
static char *versionid = GIT_COMMIT_AUTHOR " " GIT_COMMIT_DATE " " GIT_COMMIT_BRANCH " v" GIT_COMMIT_NUMBER " " GIT_COMMIT_HASH;

int main()
{
	printf("\n");
	printf("%s \n", versionid);
	return 0;
}
