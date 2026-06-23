<%@ page language="java" pageEncoding="UTF-8" %>
<%
    com.cinebooking.models.User navUser = (com.cinebooking.models.User) session.getAttribute("user");
    String CONTEXT_PATH = request.getContextPath();
%>

<style>
    /* Navbar - Glassmorphism dark theme */
    .cine-navbar-glass {
        background: linear-gradient(180deg, rgba(10,10,12,0.6), rgba(10,10,12,0.55));
        backdrop-filter: blur(10px) saturate(120%);
        -webkit-backdrop-filter: blur(10px) saturate(120%);
        border-bottom: 1px solid rgba(255,255,255,0.03);
    }

    .cine-navbar-glass .navbar-brand { font-weight:800; letter-spacing:1px; }
    .cine-brand-cine { color:#fff; }
    .cine-brand-booking { color:#e50914; }

    /* Center search */
    .cine-search-wrap { position: relative; width: 100%; max-width: 720px; }
    .cine-search-input {
        width: 100%;
        padding: 12px 44px 12px 16px;
        border-radius: 999px;
        border: 1px solid rgba(255,255,255,0.06);
        background: rgba(18,18,18,0.45);
        color: #fff;
        box-shadow: 0 6px 18px rgba(0,0,0,0.5) inset;
    }
    .cine-search-input::placeholder { color: rgba(255,255,255,0.45); }
    .cine-search-icon {
        position: absolute; right: 12px; top: 50%; transform: translateY(-50%);
        color: rgba(255,255,255,0.75); pointer-events:none;
    }

    /* Dropdown suggestions */
    .cine-suggestions {
        position: absolute; left: 0; right: 0; top: calc(100% + 10px);
        background: linear-gradient(180deg, rgba(12,12,12,0.95), rgba(6,6,6,0.95));
        border-radius: 12px; padding: 8px; z-index: 1050;
        box-shadow: 0 10px 30px rgba(0,0,0,0.6);
        max-height: 420px; overflow: auto; border: 1px solid rgba(255,255,255,0.03);
    }
    .cine-suggestion-item { display:flex; gap:12px; align-items:center; padding:8px; border-radius:8px; transition: background .12s ease; text-decoration:none; color:inherit; }
    .cine-suggestion-item:hover { background: rgba(255,255,255,0.03); }
    .cine-suggestion-thumb { width:54px; height:76px; object-fit:cover; border-radius:6px; flex:0 0 54px; }
    .cine-suggestion-title { color:#fff; font-weight:600; }
    .cine-suggestion-sub { color:rgba(255,255,255,0.6); font-size:0.88rem; }

    /* Right-side auth/login */
    .cine-login-btn { background:#e50914; color:#fff; border-radius:999px; padding:8px 16px; border:0; }
    .cine-avatar { width:36px; height:36px; border-radius:50%; border:2px solid rgba(229,9,20,0.12); object-fit:cover; }

    @media (max-width: 991px) {
        .cine-search-wrap { max-width: 520px; }
    }
</style>

<nav class="navbar navbar-expand-lg navbar-dark cine-navbar-glass sticky-top">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center gap-2" href="<%= CONTEXT_PATH %>/home">
            <span style="font-size:1.2rem;">🎬</span>
            <span class="cine-brand-cine">CINE</span><span class="cine-brand-booking">BOOKING</span>
        </a>

        <div class="d-flex flex-grow-1 justify-content-center px-3 order-3 order-lg-2">
            <div class="cine-search-wrap" id="cineSearchWrap">
                <form id="cineSearchForm" role="search" autocomplete="off">
                    <input id="cineSearchInput" class="cine-search-input" type="search" name="q" placeholder="Search movies, genres, actors..." aria-label="Search movies">
                    <div class="cine-search-icon" aria-hidden="true">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M21 21L15.8 15.8" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path>
                            <path d="M10.5 18a7.5 7.5 0 1 1 0-15 7.5 7.5 0 0 1 0 15z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path>
                        </svg>
                    </div>
                </form>
                <div id="cineSuggestions" class="cine-suggestions" style="display:none;" role="listbox" aria-label="Search suggestions"></div>
            </div>
        </div>

        <div class="order-2 order-lg-3">
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#cineNavCollapse" aria-controls="cineNavCollapse" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="cineNavCollapse">
                <ul class="navbar-nav ms-auto align-items-lg-center">
                    <li class="nav-item"><a class="nav-link" href="<%= CONTEXT_PATH %>/movies">Movies</a></li>
                    <li class="nav-item"><a class="nav-link" href="<%= CONTEXT_PATH %>/deals">Offers</a></li>

                    <% if (navUser == null) { %>
                        <li class="nav-item ms-lg-3 my-2 my-lg-0">
                            <a class="btn cine-login-btn" href="<%= CONTEXT_PATH %>/UserController?action=login">Login / Register</a>
                        </li>
                    <% } else { %>
                        <%
                            String avatarName = navUser.getName() != null ? navUser.getName() : "User";
                            String avatarUrl = "https://ui-avatars.com/api/?name=" + java.net.URLEncoder.encode(avatarName, java.nio.charset.StandardCharsets.UTF_8) + "&background=e50914&color=fff&rounded=true";
                        %>
                        <li class="nav-item dropdown ms-3">
                            <a class="nav-link dropdown-toggle d-flex align-items-center gap-2" href="#" id="cineUserDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <img src="<%= avatarUrl %>" alt="avatar" class="cine-avatar">
                                <span class="d-none d-lg-inline text-white"><%= avatarName %></span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end dropdown-menu-dark" aria-labelledby="cineUserDropdown">
                                <li><a class="dropdown-item" href="<%= CONTEXT_PATH %>/UserController?action=profile">My Profile</a></li>
                                <li><a class="dropdown-item" href="<%= CONTEXT_PATH %>/booking?action=myBookings">My Bookings</a></li>
                                <li><a class="dropdown-item" href="<%= CONTEXT_PATH %>/reviews?action=myReviews">My Reviews</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-danger" href="<%= CONTEXT_PATH %>/UserController?action=logout">Logout</a></li>
                            </ul>
                        </li>
                    <% } %>
                </ul>
            </div>
        </div>
    </div>
</nav>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    (function(){
        var ctx = '<%= CONTEXT_PATH %>';
        var input = document.getElementById('cineSearchInput');
        var suggestions = document.getElementById('cineSuggestions');
        var form = document.getElementById('cineSearchForm');
        var wrap = document.getElementById('cineSearchWrap');
        var debounceTimer = null;

        if (!input || !suggestions || !form || !wrap) return;

        function clearSuggestions(){
            suggestions.innerHTML = '';
            suggestions.style.display = 'none';
        }

        function renderSuggestions(items){
            suggestions.innerHTML = '';
            if(!items || items.length === 0){
                clearSuggestions();
                return;
            }

            items.slice(0,8).forEach(function(item){
                var a = document.createElement('a');
                a.href = ctx + '/movie-details?movieId=' + encodeURIComponent(item.id || '');
                a.className = 'cine-suggestion-item';
                a.setAttribute('role','option');
                a.setAttribute('tabindex','0');

                var img = document.createElement('img');
                img.className = 'cine-suggestion-thumb';
                img.alt = item.title || 'Poster';
                img.src = item.posterUrl || (ctx + '/images/digital-deluxe.jpg');

                var meta = document.createElement('div');
                var title = document.createElement('div');
                title.className = 'cine-suggestion-title';
                title.textContent = item.title || 'Untitled';
                var sub = document.createElement('div');
                sub.className = 'cine-suggestion-sub';
                sub.textContent = item.year ? String(item.year) : '';
                meta.appendChild(title);
                meta.appendChild(sub);

                a.appendChild(img);
                a.appendChild(meta);
                suggestions.appendChild(a);
            });
            suggestions.style.display = 'block';
        }

        function fetchSuggestions(q){
            if(!q || q.trim().length < 1){
                clearSuggestions();
                return;
            }
            fetch(ctx + '/movie-search?query=' + encodeURIComponent(q), {
                method: 'GET',
                headers: { 'Accept':'application/json' }
            })
            .then(function(res){
                if(!res.ok) throw new Error('Search failed');
                return res.json();
            })
            .then(function(data){
                renderSuggestions(Array.isArray(data) ? data : []);
            })
            .catch(function(){
                clearSuggestions();
            });
        }

        input.addEventListener('input', function(e){
            var q = e.target.value;
            if(debounceTimer) clearTimeout(debounceTimer);
            debounceTimer = setTimeout(function(){ fetchSuggestions(q); }, 300);
        });

        form.addEventListener('submit', function(e){
            e.preventDefault();
            var q = input.value && input.value.trim();
            if(!q) return;
            window.location.href = ctx + '/movies?query=' + encodeURIComponent(q);
        });

        document.addEventListener('click', function(e){
            if(!wrap.contains(e.target)) clearSuggestions();
        });

        input.addEventListener('keydown', function(e){
            if(e.key === 'Escape') clearSuggestions();
            if(e.key === 'ArrowDown') {
                var first = suggestions.querySelector('.cine-suggestion-item');
                if(first) first.focus();
            }
        });

        suggestions.addEventListener('keydown', function(e){
            var items = Array.prototype.slice.call(suggestions.querySelectorAll('.cine-suggestion-item'));
            if(!items.length) return;
            var idx = items.indexOf(document.activeElement);
            if(e.key === 'ArrowDown'){
                e.preventDefault();
                var next = items[Math.min(items.length - 1, idx + 1)];
                if(next) next.focus();
            } else if(e.key === 'ArrowUp'){
                e.preventDefault();
                var prev = items[Math.max(0, idx - 1)];
                if(prev) prev.focus(); else input.focus();
            } else if(e.key === 'Escape'){
                input.focus();
                clearSuggestions();
            }
        });

    })();
</script>
