<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layout" %>
            <%@ taglib prefix="ui" tagdir="/WEB-INF/tags/ui" %>

                <layout:mainLayout>
                    <div class="min-h-screen bg-gradient-to-br from-rose-50 to-orange-50">
                        <div class="bg-white border-b border-gray-200 shadow-sm">
                            <div class="mx-auto px-6 py-6">
                                <div class="flex items-center justify-between">
                                    <div class="flex items-center gap-4">
                                        <a href="${pageContext.request.contextPath}/flashcard/group?id=${group.id}"
                                            class="p-2 hover:bg-gray-100 rounded-full transition-colors">
                                            <jsp:include page="/assets/icon/arrowLeft.jsp">
                                                <jsp:param name="size" value="5" />
                                            </jsp:include>
                                        </a>
                                        <div>
                                            <h1 class="text-xl font-bold text-gray-900">
                                                Ôn tập: ${group.name}
                                            </h1>
                                            <p class="text-gray-600 text-sm mt-1">
                                                <c:choose>
                                                    <c:when test="${mode == 'quiz'}">
                                                        <i class="fa-solid fa-list-check text-rose-500 mr-1"></i> Trắc
                                                        nghiệm
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="fa-solid fa-link text-rose-500 mr-1"></i> Nối từ
                                                    </c:otherwise>
                                                </c:choose>
                                                •
                                                <c:choose>
                                                    <c:when test="${scope == 'favorites'}">
                                                        <i class="fa-solid fa-bookmark text-yellow-500 mr-1"></i> Thẻ đã
                                                        đánh dấu
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="fa-solid fa-layer-group text-rose-500 mr-1"></i> Toàn
                                                        bộ thẻ
                                                    </c:otherwise>
                                                </c:choose>
                                            </p>
                                        </div>
                                    </div>

                                    <div class="text-right">
                                        <div class="text-2xl font-bold text-rose-600" id="score-display">0</div>
                                        <div class="text-sm text-gray-500">Điểm</div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="max-w-4xl mx-auto px-6 py-8">
                            <c:choose>
                                <c:when test="${empty flashcards || flashcards.size() < 4}">
                                    <div class="bg-white rounded-2xl shadow-lg p-12 text-center">
                                        <i class="fa-solid fa-exclamation-circle text-yellow-500 text-5xl mb-4"></i>
                                        <h3 class="text-xl font-bold text-gray-800 mb-2">Không đủ thẻ để ôn tập</h3>
                                        <p class="text-gray-600 mb-6">Cần ít nhất 4 thẻ để bắt đầu ôn tập.
                                            <c:if test="${scope == 'favorites'}">
                                                Hãy đánh dấu thêm các thẻ hoặc chọn "Toàn bộ thẻ".
                                            </c:if>
                                        </p>
                                        <a href="${pageContext.request.contextPath}/flashcard/group?id=${group.id}"
                                            class="inline-flex items-center gap-2 px-6 py-3 bg-rose-500 text-white font-semibold rounded-xl hover:bg-rose-600 transition-colors">
                                            <i class="fa-solid fa-arrow-left"></i>
                                            Quay lại
                                        </a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:if test="${mode == 'quiz'}">
                                        <div id="quiz-container">
                                            <div class="mb-6">
                                                <div class="flex justify-between text-sm text-gray-600 mb-2">
                                                    <span>Tiến độ</span>
                                                    <span id="progress-text">1 / ${flashcards.size()}</span>
                                                </div>
                                                <div class="h-3 bg-gray-200 rounded-full overflow-hidden">
                                                    <div id="progress-bar"
                                                        class="h-full bg-gradient-to-r from-rose-400 to-orange-400 transition-all duration-300"
                                                        style="width: ${100.0 / flashcards.size()}%"></div>
                                                </div>
                                            </div>

                                            <div id="question-card" class="bg-white rounded-2xl shadow-lg p-8 mb-6">
                                                <div class="text-center mb-8">
                                                    <p class="text-sm text-gray-500 mb-2">Từ vựng</p>
                                                    <h2 id="question-term" class="text-4xl font-bold text-gray-900">
                                                    </h2>
                                                </div>

                                                <div id="options-container"
                                                    class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                                                    <!-- Các lựa chọn (JS sẽ gen ra) -->
                                                </div>
                                            </div>

                                            <div id="feedback-section" class="hidden">
                                                <div id="feedback-card" class="rounded-2xl p-6 mb-6">
                                                    <div class="flex items-center gap-4">
                                                        <div id="feedback-icon" class="text-4xl"></div>
                                                        <div>
                                                            <p id="feedback-title" class="font-bold text-lg"></p>
                                                            <p id="feedback-message" class="text-gray-600"></p>
                                                        </div>
                                                    </div>
                                                </div>
                                                <button onclick="nextQuestion()"
                                                    class="w-full py-4 bg-gradient-to-r from-rose-500 to-orange-500 text-white font-bold rounded-xl hover:from-rose-600 hover:to-orange-600 transition-all">
                                                    <span id="next-btn-text">Câu tiếp theo</span>
                                                    <i class="fa-solid fa-arrow-right ml-2"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </c:if>

                                    <c:if test="${mode == 'match'}">
                                        <div id="match-container">
                                            <div class="bg-white rounded-2xl shadow-lg p-6 mb-6">
                                                <div class="flex items-center gap-3 text-gray-700">
                                                    <i class="fa-solid fa-circle-info text-rose-500 text-xl"></i>
                                                    <p>Kéo từ cột trái và thả vào nghĩa tương ứng ở cột phải để nối.</p>
                                                </div>
                                            </div>

                                            <div id="match-game-container"
                                                class="relative bg-white rounded-2xl shadow-lg p-6">
                                                <div class="grid grid-cols-2 gap-20">
                                                    <div id="terms-column" class="space-y-4">
                                                        <!-- Thuật ngữ (JS sẽ gen ra) -->
                                                    </div>

                                                    <div id="definitions-column" class="space-y-4">
                                                        <!-- Định nghĩa (JS sẽ gen ra) -->
                                                    </div>
                                                </div>

                                                <!-- SVG overlay for drawing lines -->
                                                <svg id="match-svg"
                                                    class="absolute top-0 left-0 w-full h-full pointer-events-none"
                                                    style="z-index: 10;">
                                                    <!-- Lines will be drawn here by JavaScript -->
                                                </svg>
                                            </div>

                                            <div id="match-feedback" class="mt-6 hidden">
                                                <div
                                                    class="bg-green-100 border border-green-200 rounded-2xl p-6 text-center">
                                                    <i
                                                        class="fa-solid fa-check-circle text-green-500 text-5xl mb-4"></i>
                                                    <h3 class="text-xl font-bold text-green-800 mb-2">Hoàn thành!</h3>
                                                    <p class="text-green-700" id="match-score"></p>
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>

                                    <div id="results-overlay"
                                        class="hidden fixed inset-0 bg-black/60 backdrop-blur-sm z-50 flex items-center justify-center">
                                        <div
                                            class="bg-white rounded-3xl shadow-2xl p-8 max-w-md w-full mx-4 text-center">
                                            <div id="results-icon"
                                                class="w-24 h-24 mx-auto mb-6 rounded-full flex items-center justify-center text-5xl">
                                            </div>
                                            <h2 class="text-2xl font-bold text-gray-900 mb-2">Kết quả ôn tập</h2>
                                            <p id="results-score" class="text-4xl font-bold text-rose-600 mb-4"></p>
                                            <p id="results-message" class="text-gray-600 mb-8"></p>
                                            <div class="flex gap-4">
                                                <a href="${pageContext.request.contextPath}/flashcard/group?id=${group.id}"
                                                    class="flex-1 py-3 border-2 border-gray-200 text-gray-700 font-semibold rounded-xl hover:bg-gray-50 transition-colors">
                                                    Quay lại
                                                </a>
                                                <button onclick="location.reload()"
                                                    class="flex-1 py-3 bg-gradient-to-r from-rose-500 to-orange-500 text-white font-semibold rounded-xl hover:from-rose-600 hover:to-orange-600 transition-all">
                                                    Ôn lại
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <script>
                        //Dữ liệu tất cả các thẻ
                        const flashcards = [
                            <c:forEach var="card" items="${flashcards}" varStatus="loop">
                                {
                                    id: '${card.id}',
                                term: '${card.term}',
                                definition: '${card.definition}'
                                }<c:if test="${!loop.last}">,</c:if>
                            </c:forEach>
                        ];

                        const mode = '${mode}';
                        let currentIndex = 0;
                        let score = 0;
                        let totalQuestions = flashcards.length;

                        let selectedOption = null;
                        let hasAnswered = false;

                        let matchedPairs = 0;
                        let matchAttempts = 0;

                        document.addEventListener('DOMContentLoaded', function () {
                            if (mode === 'quiz') {
                                initQuiz();
                            } else if (mode === 'match') {
                                initMatch();
                            }
                        });

                        function initQuiz() {
                            showQuestion();
                        }

                        function showQuestion() {
                            if (currentIndex >= flashcards.length) {
                                showResults();
                                return;
                            }

                            const card = flashcards[currentIndex];
                            document.getElementById('question-term').textContent = card.term;

                            const options = generateOptions(card);
                            renderOptions(options, card.definition);

                            document.getElementById('feedback-section').classList.add('hidden');
                            document.getElementById('question-card').classList.remove('opacity-50');

                            updateProgress();

                            hasAnswered = false;
                        }

                        //Tạo và gen ra đáp án -> xáo trộn ngẫu nhiên
                        function generateOptions(currentCard) {
                            const wrongOptions = flashcards
                                .filter(c => c.id !== currentCard.id)
                                .sort(() => Math.random() - 0.5)
                                .slice(0, 3)
                                .map(c => c.definition);

                            const allOptions = [...wrongOptions, currentCard.definition];
                            return allOptions.sort(() => Math.random() - 0.5);
                        }

                        function renderOptions(options, correctAnswer) {
                            const container = document.getElementById('options-container');
                            container.innerHTML = '';

                            options.forEach((option, index) => {
                                const btn = document.createElement('button');
                                btn.className = 'p-4 text-left border-2 border-gray-200 rounded-xl hover:border-rose-400 hover:bg-rose-50 transition-all font-medium text-gray-800';
                                btn.textContent = option;
                                btn.onclick = () => selectAnswer(option, correctAnswer, btn);
                                container.appendChild(btn);
                            });
                        }

                        function selectAnswer(selected, correct, btn) {
                            if (hasAnswered) return;
                            hasAnswered = true;

                            const isCorrect = selected === correct;
                            const feedbackSection = document.getElementById('feedback-section');
                            const feedbackCard = document.getElementById('feedback-card');
                            const feedbackIcon = document.getElementById('feedback-icon');
                            const feedbackTitle = document.getElementById('feedback-title');
                            const feedbackMessage = document.getElementById('feedback-message');

                            document.querySelectorAll('#options-container button').forEach(optBtn => {
                                optBtn.disabled = true;
                                if (optBtn.textContent === correct) {
                                    optBtn.classList.add('border-green-500', 'bg-green-50', 'text-green-800');
                                } else if (optBtn === btn && !isCorrect) {
                                    optBtn.classList.add('border-red-500', 'bg-red-50', 'text-red-800');
                                } else {
                                    optBtn.classList.add('opacity-50');
                                }
                            });

                            if (isCorrect) {
                                score++;
                                document.getElementById('score-display').textContent = score;
                                feedbackCard.className = 'rounded-2xl p-6 mb-6 bg-green-100 border border-green-200';
                                feedbackIcon.innerHTML = '<i class="fa-solid fa-check-circle text-green-500"></i>';
                                feedbackTitle.textContent = 'せいかい！Chính xác!';
                                feedbackTitle.className = 'font-bold text-lg text-green-800';
                                feedbackMessage.textContent = 'Tiếp tục phát huy nhé!';
                            } else {
                                feedbackCard.className = 'rounded-2xl p-6 mb-6 bg-red-100 border border-red-200';
                                feedbackIcon.innerHTML = '<i class="fa-solid fa-times-circle text-red-500"></i>';
                                feedbackTitle.textContent = 'ざんねん！Sai rồi!';
                                feedbackTitle.className = 'font-bold text-lg text-red-800';
                                feedbackMessage.textContent = 'Đáp án đúng là: ' + correct;
                            }

                            if (currentIndex === flashcards.length - 1) {
                                document.getElementById('next-btn-text').textContent = 'Xem kết quả';
                            }

                            feedbackSection.classList.remove('hidden');
                            document.getElementById('question-card').classList.add('opacity-50');

                            submitAnswer(flashcards[currentIndex].id, isCorrect);
                        }

                        function nextQuestion() {
                            currentIndex++;
                            showQuestion();
                        }

                        function updateProgress() {
                            const progress = ((currentIndex + 1) / totalQuestions) * 100;
                            document.getElementById('progress-bar').style.width = progress + '%';
                            document.getElementById('progress-text').textContent = (currentIndex + 1) + ' / ' + totalQuestions;
                        }

                        let draggingCard = null;
                        let dragStartPos = null;
                        let currentLine = null;
                        let permanentLines = [];
                        let matchedCards = new Set();

                        function initMatch() {
                            const termsColumn = document.getElementById('terms-column');
                            const defsColumn = document.getElementById('definitions-column');

                            const shuffledTerms = [...flashcards].sort(() => Math.random() - 0.5);
                            const shuffledDefs = [...flashcards].sort(() => Math.random() - 0.5);

                            shuffledTerms.forEach(card => {
                                const div = document.createElement('div');
                                div.id = 'term-' + card.id;
                                div.className = 'p-4 bg-white rounded-xl shadow border-2 border-gray-200 cursor-grab hover:border-blue-400 hover:shadow-lg transition-all font-semibold text-gray-800 text-center select-none';
                                div.textContent = card.term;
                                div.dataset.cardId = card.id;
                                div.dataset.cardType = 'term';
                                div.addEventListener('mousedown', handleTermMouseDown);
                                termsColumn.appendChild(div);
                            });

                            shuffledDefs.forEach(card => {
                                const div = document.createElement('div');
                                div.id = 'def-' + card.id;
                                div.className = 'p-4 bg-white rounded-xl shadow border-2 border-gray-200 transition-all text-gray-700 text-center select-none';
                                div.textContent = card.definition;
                                div.dataset.cardId = card.id;
                                div.dataset.cardType = 'def';
                                defsColumn.appendChild(div);
                            });

                            document.addEventListener('mousemove', handleMouseMove);
                            document.addEventListener('mouseup', handleMouseUp);
                            window.addEventListener('resize', updateAllLines);
                        }

                        function handleTermMouseDown(e) {
                            e.preventDefault();
                            const element = e.currentTarget;

                            if (matchedCards.has(element.dataset.cardId)) {
                                return;
                            }

                            draggingCard = {
                                id: element.dataset.cardId,
                                element: element
                            };

                            const pos = getCardPoint(element, 'right');
                            dragStartPos = pos;

                            currentLine = createSVGLine(pos.x, pos.y, pos.x, pos.y, 'temp');
                            document.getElementById('match-svg').appendChild(currentLine);

                            element.style.cursor = 'grabbing';
                        }

                        function handleMouseMove(e) {
                            if (!draggingCard || !currentLine) return;

                            const container = document.getElementById('match-game-container');
                            const rect = container.getBoundingClientRect();
                            const x = e.clientX - rect.left;
                            const y = e.clientY - rect.top;

                            if (x > dragStartPos.x) {
                                currentLine.setAttribute('x2', x);
                                currentLine.setAttribute('y2', y);
                            } else {
                                currentLine.setAttribute('x2', dragStartPos.x);
                                currentLine.setAttribute('y2', dragStartPos.y);
                            }
                        }

                        function handleMouseUp(e) {
                            if (!draggingCard) return;

                            if (currentLine) {
                                currentLine.remove();
                                currentLine = null;
                            }

                            draggingCard.element.style.cursor = 'grab';

                            const dropTarget = document.elementFromPoint(e.clientX, e.clientY);
                            const defCard = dropTarget?.closest('[data-card-type="def"]');

                            if (defCard && !matchedCards.has(defCard.dataset.cardId)) {
                                const termId = draggingCard.id;
                                const defId = defCard.dataset.cardId;

                                matchAttempts++;

                                if (termId === defId) {
                                    //Nối đúng
                                    score++;
                                    matchedPairs++;
                                    document.getElementById('score-display').textContent = score;

                                    matchedCards.add(termId);
                                    matchedCards.add(defId);

                                    draggingCard.element.classList.remove('border-gray-200', 'hover:border-blue-400');
                                    draggingCard.element.classList.add('border-green-300', '!bg-green-100');
                                    draggingCard.element.style.cursor = 'default';

                                    defCard.classList.remove('border-gray-200');
                                    defCard.classList.add('border-green-300', '!bg-green-100');

                                    const startPos = getCardPoint(draggingCard.element, 'right');
                                    const endPos = getCardPoint(defCard, 'left');
                                    const line = createSVGLine(startPos.x, startPos.y, endPos.x, endPos.y, 'permanent');
                                    permanentLines.push({
                                        line: line,
                                        termId: termId,
                                        defId: defId
                                    });
                                    document.getElementById('match-svg').appendChild(line);

                                    submitAnswer(defId, true);

                                    // Check nếu tất cả đều nối đúng
                                    if (matchedPairs === flashcards.length) {
                                        setTimeout(() => {
                                            document.getElementById('match-feedback').classList.remove('hidden');
                                            document.getElementById('match-score').textContent =
                                                'Bạn đã nối đúng ' + score + '/' + flashcards.length + ' cặp!';
                                            showResults();
                                        }, 500);
                                    }
                                } else {
                                    // Nối sai
                                    const wrongTermElement = draggingCard.element;
                                    wrongTermElement.classList.add('border-red-500', '!bg-red-50');
                                    defCard.classList.add('border-red-500', '!bg-red-50');

                                    setTimeout(() => {
                                        wrongTermElement.classList.remove('border-red-500', '!bg-red-50');
                                        defCard.classList.remove('border-red-500', '!bg-red-50');
                                    }, 500);
                                }
                            }

                            draggingCard = null;
                            dragStartPos = null;
                        }

                        function getCardPoint(element, side) {
                            const container = document.getElementById('match-game-container');
                            const containerRect = container.getBoundingClientRect();
                            const elementRect = element.getBoundingClientRect();

                            const x = side === 'right'
                                ? elementRect.right - containerRect.left
                                : elementRect.left - containerRect.left;
                            const y = elementRect.top - containerRect.top + elementRect.height / 2;

                            return { x, y };
                        }

                        function createSVGLine(x1, y1, x2, y2, type) {
                            const line = document.createElementNS('http://www.w3.org/2000/svg', 'line');
                            line.setAttribute('x1', x1);
                            line.setAttribute('y1', y1);
                            line.setAttribute('x2', x2);
                            line.setAttribute('y2', y2);
                            line.setAttribute('stroke', type === 'permanent' ? '#3b82f6' : '#3b82f6');
                            line.setAttribute('stroke-width', '3');
                            line.setAttribute('stroke-linecap', 'round');
                            return line;
                        }

                        function updateAllLines() {
                            permanentLines.forEach(lineData => {
                                const termElement = document.getElementById('term-' + lineData.termId);
                                const defElement = document.getElementById('def-' + lineData.defId);

                                if (termElement && defElement) {
                                    const startPos = getCardPoint(termElement, 'right');
                                    const endPos = getCardPoint(defElement, 'left');

                                    lineData.line.setAttribute('x1', startPos.x);
                                    lineData.line.setAttribute('y1', startPos.y);
                                    lineData.line.setAttribute('x2', endPos.x);
                                    lineData.line.setAttribute('y2', endPos.y);
                                }
                            });
                        }

                        async function submitAnswer(flashcardId, isCorrect) {
                            try {
                                await fetch('${pageContext.request.contextPath}/flashcard/review', {
                                    method: 'POST',
                                    headers: {
                                        'Content-Type': 'application/x-www-form-urlencoded'
                                    },
                                    body: 'flashcardId=' + flashcardId + '&isCorrect=' + isCorrect
                                });
                            } catch (error) {
                                console.error('Error submitting answer:', error);
                            }
                        }

                        function showResults() {
                            const overlay = document.getElementById('results-overlay');
                            const icon = document.getElementById('results-icon');
                            const scoreText = document.getElementById('results-score');
                            const message = document.getElementById('results-message');

                            const percentage = Math.round((score / totalQuestions) * 100);
                            scoreText.textContent = score + '/' + totalQuestions + ' (' + percentage + '%)';

                            if (percentage >= 80) {
                                icon.className = 'w-24 h-24 mx-auto mb-6 rounded-full flex items-center justify-center text-5xl bg-green-100';
                                icon.innerHTML = '<i class="fa-solid fa-trophy text-yellow-500"></i>';
                                message.textContent = 'Xuất sắc! Bạn đã làm rất tốt! 🎉';
                            } else if (percentage >= 50) {
                                icon.className = 'w-24 h-24 mx-auto mb-6 rounded-full flex items-center justify-center text-5xl bg-blue-100';
                                icon.innerHTML = '<i class="fa-solid fa-thumbs-up text-blue-500"></i>';
                                message.textContent = 'Tốt lắm! Hãy tiếp tục ôn tập để cải thiện nhé!';
                            } else {
                                icon.className = 'w-24 h-24 mx-auto mb-6 rounded-full flex items-center justify-center text-5xl bg-orange-100';
                                icon.innerHTML = '<i class="fa-solid fa-book-open text-orange-500"></i>';
                                message.textContent = 'Đừng nản chí! Hãy ôn lại các thẻ và thử lại nhé!';
                            }

                            overlay.classList.remove('hidden');
                        }
                    </script>

                    <style>
                        @keyframes shake {

                            0%,
                            100% {
                                transform: translateX(0);
                            }

                            25% {
                                transform: translateX(-5px);
                            }

                            75% {
                                transform: translateX(5px);
                            }
                        }

                        .animate-shake {
                            animation: shake 0.3s ease-in-out;
                        }
                    </style>
                </layout:mainLayout>