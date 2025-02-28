// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "./controllers"
import "@popperjs/core"
import "bootstrap"

document.addEventListener("DOMContentLoaded", () => {
  const heartIcons = document.querySelectorAll(".heart-icon");
  const infoButtons = document.querySelectorAll(".show-info");

  heartIcons.forEach(icon => {
    icon.addEventListener("click", (event) => {
      event.preventDefault();
      const movieId = icon.getAttribute("data-movie-id");
      
      // Récupérer toutes les listes disponibles
      fetch('/lists.json')
        .then(response => response.json())
        .then(lists => {
          if (lists.length === 0) {
            alert("You don't have any lists yet. Create a list first!");
            return;
          }
          
          // Créer une liste de choix pour l'utilisateur
          let listOptions = "Choose a list to add this movie to:\n";
          lists.forEach((list, index) => {
            listOptions += `${index + 1}. ${list.name}\n`;
          });
          
          const listIndex = prompt(listOptions);
          
          if (listIndex && listIndex > 0 && listIndex <= lists.length) {
            const selectedList = lists[listIndex - 1];
            
            // Rediriger vers le formulaire de création de bookmark
            window.location.href = `/lists/${selectedList.id}/bookmarks/new?movie_id=${movieId}`;
          }
        })
        .catch(error => {
          console.error('Error:', error);
          alert("An error occurred while fetching your lists.");
        });
    });
  });

  infoButtons.forEach(button => {
    button.addEventListener("click", (event) => {
      event.preventDefault();
      const movieId = button.getAttribute("data-movie-id");

      // Récupérer les informations du film
      fetch(`/movies/${movieId}/show_json`)
        .then(response => response.json())
        .then(movie => {
          // Remplir le modal avec les informations du film
          document.getElementById("modalMovieTitle").innerText = movie.title;
          document.getElementById("modalMoviePoster").src = `${window.location.origin}/#{movie.poster_url}`;
          document.getElementById("modalMovieOverview").innerText = movie.overview;
          document.getElementById("modalMovieRating").innerText = movie.rating;

          // Afficher le modal
          const modal = new bootstrap.Modal(document.getElementById('movieInfoModal'));
          modal.show();
        })
        .catch(error => {
          console.error('Error:', error);
          alert("An error occurred while fetching movie details.");
        });
    });
  });
});