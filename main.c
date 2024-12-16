#include <stdio.h>
#include <stdlib.h>

int main()
{
    int choice;
    // Affichage de l'ASCII Art en rouge
    printf("\033[1;31m"); // Rouge en gras
    printf(" .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------. \n");
    printf("| .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |\n");
    printf("| |     ______   | || |              | || | _____  _____ | || |     _____    | || |  _______     | || |  _________   | |\n");
    printf("| |   .' ___  |  | || |              | || ||_   _||_   _|| || |    |_   _|   | || | |_   __ \\    | || | |_   ___  |  | |\n");
    printf("| |  / .'   \\_|  | || |              | || |  | | /\ | |  | || |      | |     | || |   | |__) |   | || |   | |_  \\_|  | |\n");
    printf("| |  | |         | || |              | || |  | |/  \\| |  | || |      | |     | || |   |  __ /    | || |   |  _|  _   | |\n");
    printf("| |  \\ `.___.'\\  | || |              | || |  |   /\\   |  | || |     _| |_    | || |  _| |  \\ \\_  | || |  _| |___/ |  | |\n");
    printf("| |   `._____.`  | || |   _______    | || |  |__/  \\__|  | || |    |_____|   | || | |____| |___| | || | |_________|  | |\n");
    printf("| |              | || |  |_______|   | || |              | || |              | || |              | || |              | |\n");
    printf("| '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |\n");
    printf(" '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------' \n");
    printf("\033[0m"); // Réinitialiser les couleurs

    // Lancer le fichier audio en arrière-plan
        if (system("start /min musique.mp3") != 0) {
            printf("Erreur : impossible de lancer musique.mp3\n");
        } else {
            printf("Musique lancée en arrière-plan !\n");
        }

    printf("\n");
    printf("\n");
    printf("\n");
    printf("\n");
    printf("\n");
    printf("\n");
    printf("\n");
    printf("                         (@@@@@@@@%\n");
    printf("                      &@,           @@\n");
    printf("                    @@                @(\n");
    printf("                  (@                   @&     .#&@@@%*                   #@@#,  .(@@@@(\n");
    printf("                 *@                       /#*          *@@,     *&@@@@@#                @@\n");
    printf("                 &%                                       ,@,                            .@.\n");
    printf("                 @%                                        .@                             &&\n");
    printf("                 @%                                        .@                              @/\n");
    printf("                 @.                                        /@                               #@(\n");
    printf("                @*                                         .@                                  .@@\n");
    printf("               #@                                           %@                                    @#\n");
    printf("               /@                     #@@@@@(                *&,                                  .@\n");
    printf("                &@                 /&*       %@,               #@                                 /@\n");
    printf("                 .@&             #&/           @@               %@                                @/\n");
    printf("                    *@@@#//#&@@@,               @(              @(                             *@@\n");
    printf("                                                &%            .@,                         (@@,\n");
    printf("                                               .@            %@            #@&          *&.\n");
    printf("                                                                              @,        @.\n");
    printf("                                             @%                .@             #@       @%\n");
    printf("                                             @,                 @/\n");
    printf("                                           .@                  &%        *@               @( \n");
    printf("                                            #@                  /@        #@               &&\n");
    printf("                                            @,                   @(       @#               /@\n");
    printf("                                           @&                    ,@      .@                 @*\n");
    printf("                                          (@   %&#@&      /@,@@   #@     @#                 /@\n");
    printf("                                         .@  %@    %@    &@    &@  @%   %@                   &&\n");
    printf("                                         @( @&      *&  @%      *@  @* /@                     @(\n");
    printf("                                        && .@        @&#@,       @# ,@                        .@\n");
    printf("                                       /@   @@@&#/.  @@@@  .*#&@@@(  %@                        (@\n");
    printf("                                       @.          &@    &@           @%                        &&\n");
    printf("                                      @(         (@.       @@          @,                        @/\n");
    printf("                                     &&         &@&.       #@@         *@                        .@\n");
    printf("                                    *@                ,,.               %@                        #@\n");
    printf("                                    @,                                   @#                        @%\n");
    printf("                                   *@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@@\n");
    printf("\n");
    printf("\n");
    printf("\n");
    printf("\n");
    printf("\n");
    printf("\n");
    printf("\n");
    printf("\n");
    printf("                         *  &,# *% % #.& (,...#...%% ..,% /&.*%  %   & % /  ,% /  , & %&   ,* & &\n");

// Commande pour effacer l'écran en fonction du système d'exploitation
#if defined(_WIN32) || defined(_WIN64)
    system("cls"); // Commande pour Windows
#else
    system("clear"); // Commande pour Linux/Mac
#endif

    printf("Do you want to run your C_wire data processing program: (1 =yes , 2=no)\n");
    scanf("%d", &choice);
    if (choice == 1)
    {
        // Exécuter le script via Git Bash
        int ret_code = system("\"C:\\Git\\Git\\bin\\bash.exe\" \"C:\\Users\\Dorian RISPOT\\Projets\\CYTech\\Projet-C_wire\\SHELL\\c_wire.sh\"");
    }
    return 0;
}
