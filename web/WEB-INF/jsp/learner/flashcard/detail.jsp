<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layout" %>
            <%@ taglib prefix="ui" tagdir="/WEB-INF/tags/ui" %>
                <layout:mainLayout>
                    <div class="min-h-screen bg-gradient-to-br from-rose-50 to-orange-50">
                        <div class="bg-white border-b border-gray-200 shadow-sm">
                            <div class="max-w-7xl mx-auto px-6 py-6">
                                <div class="flex items-center justify-between">
                                    <div class="flex items-center gap-4">
                                        <a href="${pageContext.request.contextPath}/flashcard"
                                            class="p-2 hover:bg-gray-100 rounded-full transition-colors">
                                            <jsp:include page="/assets/icon/arrowLeft.jsp">
                                                <jsp:param name="size" value="5" />
                                            </jsp:include>
                                        </a>
                                        <div>
                                            <h1 class="text-2xl font-bold text-gray-900">${group.name}</h1>
                                            <p class="text-gray-600 text-sm mt-1">${flashcards.size()} thẻ trong bộ này
                                            </p>
                                        </div>
                                    </div>

                                    <button onclick="openDialog('review-modal')"
                                        class="px-6 py-3 bg-gradient-to-r from-rose-500 to-orange-500 text-white font-semibold rounded-xl hover:from-rose-600 hover:to-orange-600 transition-all shadow-lg hover:shadow-xl flex items-center gap-2">
                                        <i class="fa-solid fa-graduation-cap"></i>
                                        <span>Ôn tập</span>
                                    </button>
                                </div>
                            </div>
                        </div>

                        <div class="max-w-7xl mx-auto px-10 py-8">
                            <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                                <div class="lg:col-span-2">
                                    <div class="bg-white rounded-2xl shadow-lg p-6 border border-gray-100">
                                        <h2 class="text-lg font-bold text-gray-900 mb-4 flex items-center gap-2">
                                            <i class="fa-solid fa-clone text-rose-500"></i>
                                            Tất cả thẻ
                                        </h2>

                                        <c:choose>
                                            <c:when test="${empty flashcards}">
                                                <div class="text-center py-12">
                                                    <i class="fa-solid fa-inbox text-gray-300 text-5xl mb-4"></i>
                                                    <p class="text-gray-500">Bộ thẻ này chưa có thẻ nào.</p>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <ui:carousel id="flashcard-carousel" className="mb-6">
                                                    <ui:carouselContent>
                                                        <c:forEach var="card" items="${flashcards}" varStatus="loop">
                                                            <ui:carouselItem>
                                                                <div class="relative">
                                                                    <ui:button variant="ghost"
                                                                        onclick="event.stopPropagation(); toggleBookmark('${card.id}')"
                                                                        className="absolute top-2 right-2 z-10 !rounded-full transition-colors ${favoriteIds.contains(card.id) ? 'text-yellow-500' : 'text-gray-400'}"
                                                                        id="bookmark-btn-${card.id}" size="icon">
                                                                        <jsp:include page="/assets/icon/bookmark.jsp">
                                                                            <jsp:param name="size" value="5" />
                                                                            <jsp:param name="id"
                                                                                value="bookmark-icon-${card.id}" />
                                                                            <jsp:param name="className"
                                                                                value="${favoriteIds.contains(card.id) ? 'fill-yellow-500 stroke-yellow-500' : 'stroke-black'}" />
                                                                        </jsp:include>
                                                                    </ui:button>

                                                                    <ui:flipCard id="card-${card.id}"
                                                                        term="${card.term}"
                                                                        definition="${card.definition}"
                                                                        termImage="${card.termImageUrl}"
                                                                        definitionImage="${card.definitionImageUrl}" />
                                                                </div>
                                                            </ui:carouselItem>
                                                        </c:forEach>
                                                    </ui:carouselContent>
                                                    <div class="flex items-center justify-center gap-4 mt-6">
                                                        <ui:carouselPrevious />
                                                        <span class="text-gray-500 text-sm" id="card-counter">1 /
                                                            ${flashcards.size()}</span>
                                                        <ui:carouselNext />
                                                    </div>
                                                </ui:carousel>

                                                <div class="flex justify-center gap-2 mt-4">
                                                    <c:forEach var="card" items="${flashcards}" varStatus="loop">
                                                        <div class="w-2 h-2 rounded-full bg-gray-300 transition-colors"
                                                            id="dot-${loop.index}"></div>
                                                    </c:forEach>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <div class="lg:col-span-1">
                                    <div class="bg-white rounded-2xl shadow-lg p-6 border border-gray-100 sticky top-4">
                                        <h2 class="text-lg font-bold text-gray-900 mb-4 flex items-center gap-2">
                                            <jsp:include page="/assets/icon/bookmark.jsp">
                                                <jsp:param name="className" value="text-yellow-500 fill-yellow-500" />
                                            </jsp:include>
                                            Thẻ đã đánh dấu
                                            <span class="ml-auto text-sm font-normal text-gray-500"
                                                id="favorites-count">
                                                (${favoriteFlashcards.size()})
                                            </span>
                                        </h2>

                                        <div id="favorites-list" class="space-y-3 max-h-[500px] overflow-y-auto">
                                            <c:choose>
                                                <c:when test="${empty favoriteFlashcards}">
                                                    <div id="empty-favorites" class="text-center py-8 text-gray-500">
                                                        <div class="w-full flex justify-center">
                                                            <jsp:include page="/assets/icon/bookmark.jsp">
                                                                <jsp:param name="size" value="10" />
                                                                <jsp:param name="className"
                                                                    value="text-center text-gray-300 mb-2" />
                                                            </jsp:include>
                                                        </div>
                                                        <p class="text-sm">Chưa có thẻ nào được đánh dấu.</p>
                                                        <p class="text-xs mt-1">Nhấn vào biểu tượng dấu trang để lưu
                                                            thẻ.</p>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach var="card" items="${favoriteFlashcards}">
                                                        <div id="favorite-item-${card.id}"
                                                            class="p-3 bg-gradient-to-r from-yellow-50 to-orange-50 rounded-xl border border-yellow-200 hover:shadow-md transition-shadow cursor-pointer"
                                                            onclick="scrollToCard('${card.id}')">
                                                            <p class="font-semibold text-gray-800 truncate">${card.term}
                                                            </p>
                                                            <p class="text-sm text-gray-600 truncate">${card.definition}
                                                            </p>
                                                        </div>
                                                    </c:forEach>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <ui:dialog id="review-modal" className="max-w-md">
                        <ui:dialogHeader>
                            <ui:dialogTitle>Chọn chế độ ôn tập</ui:dialogTitle>
                            <ui:dialogDescription>Chọn hình thức và phạm vi thẻ để ôn tập</ui:dialogDescription>
                        </ui:dialogHeader>

                        <form id="review-form" method="get" action="${pageContext.request.contextPath}/flashcard/review"
                            class="mt-4 space-y-6">
                            <input type="hidden" name="groupId" value="${group.id}" />

                            <div>
                                <label class="block text-sm font-semibold text-gray-700 mb-3">Hình thức ôn tập</label>
                                <div class="grid grid-cols-2 gap-3">
                                    <label
                                        class="flex flex-col items-center p-4 border-2 border-gray-200 rounded-xl cursor-pointer hover:border-rose-400 hover:bg-rose-50 transition-colors has-[:checked]:border-rose-500 has-[:checked]:bg-rose-50">
                                        <input type="radio" name="mode" value="quiz" class="sr-only" checked />
                                        <i class="fa-solid fa-list-check text-2xl text-rose-500 mb-2"></i>
                                        <span class="font-medium text-gray-900">Trắc nghiệm</span>
                                    </label>
                                    <label
                                        class="flex flex-col items-center p-4 border-2 border-gray-200 rounded-xl cursor-pointer hover:border-rose-400 hover:bg-rose-50 transition-colors has-[:checked]:border-rose-500 has-[:checked]:bg-rose-50">
                                        <input type="radio" name="mode" value="match" class="sr-only" />
                                        <i class="fa-solid fa-link text-2xl text-rose-500 mb-2"></i>
                                        <span class="font-medium text-gray-900">Nối</span>
                                    </label>
                                </div>
                            </div>

                            <div>
                                <label class="block text-sm font-semibold text-gray-700 mb-3">Phạm vi</label>
                                <div class="grid grid-cols-2 gap-3">
                                    <label
                                        class="flex flex-col items-center p-4 border-2 border-gray-200 rounded-xl cursor-pointer hover:border-rose-400 hover:bg-rose-50 transition-colors has-[:checked]:border-rose-500 has-[:checked]:bg-rose-50">
                                        <input type="radio" name="scope" value="all" class="sr-only" checked />
                                        <i class="fa-solid fa-layer-group text-2xl text-rose-500 mb-2"></i>
                                        <span class="font-medium text-gray-900">Toàn bộ thẻ</span>
                                    </label>
                                    <label
                                        class="flex flex-col items-center p-4 border-2 border-gray-200 rounded-xl cursor-pointer hover:border-rose-400 hover:bg-rose-50 transition-colors has-[:checked]:border-rose-500 has-[:checked]:bg-rose-50">
                                        <input type="radio" name="scope" value="favorites" class="sr-only" />
                                        <jsp:include page="/assets/icon/bookmark.jsp">
                                            <jsp:param name="className" value="text-yellow-500 fill-yellow-500" />
                                        </jsp:include>
                                        <span class="font-medium text-gray-900">Thẻ đã đánh dấu</span>
                                    </label>
                                </div>
                            </div>

                            <ui:dialogFooter>
                                <ui:button type="button" variant="outline" onclick="closeDialog(this)">Hủy</ui:button>
                                <ui:button type="submit">
                                    <i class="fa-solid fa-play mr-2"></i>
                                    Bắt đầu
                                </ui:button>
                            </ui:dialogFooter>
                        </form>
                    </ui:dialog>

                    <script>
                        //Dữ liệu tất cả các thẻ
                        const flashcardsData = {
                            <c:forEach var="card" items="${flashcards}" varStatus="loop">
                                '${card.id}': {
                                    term: '${card.term}',
                                    definition: '${card.definition}',
                                    isFavorite: ${ favoriteIds.contains(card.id) }
                                } <c:if test="${!loop.last}">,</c:if>
                            </c:forEach>
                        };
                        //Sử dụng AJAX để gọi hàm trong servlet => đánh dấu thẻ
                        async function toggleBookmark(flashcardId) {
                            try {
                                const response = await fetch('${pageContext.request.contextPath}/flashcard/bookmark', {
                                    method: 'POST',
                                    headers: {
                                        'Content-Type': 'application/x-www-form-urlencoded',
                                    },
                                    body: 'flashcardId=' + flashcardId
                                });
                                const data = await response.json();
                                if (data.success) {
                                    updateBookmarkUI(flashcardId, data.isFavorite);
                                }
                            } catch (error) {
                                console.error('Error toggling bookmark:', error);
                            }
                        }

                        //Đánh dấu/hủy đánh dấu thẻ
                        function updateBookmarkUI(flashcardId, isFavorite) {
                            const btn = document.getElementById('bookmark-btn-' + flashcardId);
                            const icon = document.getElementById('bookmark-icon-' + flashcardId);
                            const favoriteItem = document.getElementById('favorite-item-' + flashcardId);
                            const favoritesList = document.getElementById('favorites-list');
                            const emptyFavorites = document.getElementById('empty-favorites');
                            const favoritesCount = document.getElementById('favorites-count');
                            if (isFavorite) {
                                btn.classList.remove('text-gray-400');
                                btn.classList.add('text-yellow-500');
                                icon.classList.remove('stroke-black');
                                icon.classList.add('fill-yellow-500', 'stroke-yellow-500');
                                if (!favoriteItem) {
                                    const cardData = flashcardsData[flashcardId];
                                    const newItem = document.createElement('div');
                                    newItem.id = 'favorite-item-' + flashcardId;
                                    newItem.className = 'p-3 bg-gradient-to-r from-yellow-50 to-orange-50 rounded-xl border border-yellow-200 hover:shadow-md transition-shadow cursor-pointer';
                                    newItem.onclick = () => scrollToCard(flashcardId);
                                    newItem.innerHTML = '<p class="font-semibold text-gray-800 truncate">' + cardData.term + '</p>' +
                                        '<p class="text-sm text-gray-600 truncate">' + cardData.definition + '</p>';
                                    if (emptyFavorites) {
                                        emptyFavorites.style.display = 'none';
                                    }
                                    favoritesList.appendChild(newItem);
                                }
                            } else {
                                btn.classList.remove('text-yellow-500');
                                btn.classList.add('text-gray-400');
                                icon.classList.remove('fill-yellow-500', 'stroke-yellow-500');
                                icon.classList.add('stroke-black');
                                if (favoriteItem) {
                                    favoriteItem.remove();
                                    if (favoritesList.children.length === 0 ||
                                        (favoritesList.children.length === 1 && favoritesList.children[0].id === 'empty-favorites')) {
                                        if (!emptyFavorites) {
                                            favoritesList.innerHTML = '<div id="empty-favorites" class="text-center py-8 text-gray-500">' +
                                                '<i class="fa-regular fa-bookmark text-3xl mb-3 block text-gray-300"></i>' +
                                                '<p class="text-sm">Chưa có thẻ nào được đánh dấu.</p>' +
                                                '<p class="text-xs mt-1">Nhấn vào biểu tượng dấu trang để lưu thẻ.</p></div>';
                                        } else {
                                            emptyFavorites.style.display = 'block';
                                        }
                                    }
                                }
                            }

                            const count = favoritesList.querySelectorAll('[id^="favorite-item-"]').length;
                            favoritesCount.textContent = '(' + count + ')';
                            flashcardsData[flashcardId].isFavorite = isFavorite;
                        }

                        //Cuộn sang thẻ nào đó
                        function scrollToCard(flashcardId) {
                            const flashcardIds = Object.keys(flashcardsData);
                            const index = flashcardIds.indexOf(flashcardId);
                            if (index >= 0) {
                                const carousel = document.getElementById('flashcard-carousel');
                                const scrollAmount = carousel.clientWidth * index;
                                carousel.scrollTo({
                                    left: scrollAmount,
                                    behavior: 'smooth'
                                });
                            }
                        }

                        //Thiết lập tiến trình ban đầu cho bộ thẻ
                        document.addEventListener('DOMContentLoaded', function () {
                            const carousel = document.getElementById('flashcard-carousel');
                            const counter = document.getElementById('card-counter');
                            const totalCards = ${flashcards.size()};
                            if (carousel && counter) {
                                carousel.addEventListener('scroll', function () {
                                    updateFlashcardProgress(carousel, counter, totalCards);
                                });
                                updateFlashcardProgress(carousel, counter, totalCards); //Cập nhật khi lần đầu load trang
                            }
                        });
                        //Cập nhật tiến trình trong bộ thẻ
                        function updateFlashcardProgress(carousel, counter, totalCards) {
                            const currentIndex = Math.round(carousel.scrollLeft / carousel.clientWidth) + 1;
                            counter.textContent = currentIndex + ' / ' + totalCards;
                            for (let i = 0; i < totalCards; i++) {
                                const dot = document.getElementById('dot-' + i);
                                if (dot) {
                                    if (i === currentIndex - 1) {
                                        dot.classList.remove('bg-gray-300');
                                        dot.classList.add('bg-rose-500');
                                    } else {
                                        dot.classList.remove('bg-rose-500');
                                        dot.classList.add('bg-gray-300');
                                    }
                                }
                            }
                        }
                    </script>
                </layout:mainLayout>